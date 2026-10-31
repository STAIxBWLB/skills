"""Wiki-link graph primitives for skill-mine's virtual vault.

Moved from the retired lib/build-graph.py (vault graphs are built by vmem).
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

import networkx as nx

FRONTMATTER_RE = re.compile(r"^---\s*\n(.*?)\n---\s*\n", re.DOTALL)

WIKILINK_RE = re.compile(r"\[\[([^\]|]+?)(?:\|[^\]]+?)?\]\]")


def parse_frontmatter(text: str) -> dict:
    m = FRONTMATTER_RE.match(text)
    if not m:
        return {}
    fm = {}
    for line in m.group(1).splitlines():
        line = line.strip()
        if not line or line.startswith("#") or ":" not in line:
            continue
        key, _, val = line.partition(":")
        key, val = key.strip(), val.strip()
        if val and val[0] in ('"', "'") and val[-1] == val[0]:
            val = val[1:-1]
        if val.startswith("[") and val.endswith("]"):
            items = [s.strip().strip('"').strip("'") for s in val[1:-1].split(",") if s.strip()]
            fm[key] = items
        else:
            fm[key] = val
    return fm


def extract_body(text: str) -> str:
    m = FRONTMATTER_RE.match(text)
    return text[m.end():] if m else text


def _safe_load_fm(text: str) -> dict:
    m = FRONTMATTER_RE.match(text)
    if not m:
        return {}
    try:
        import yaml
        data = yaml.safe_load(m.group(1))
        return data if isinstance(data, dict) else {}
    except Exception:
        return {}


def extract_wiki(target: Path) -> list[dict]:
    notes_dir = target / "notes" if (target / "notes").is_dir() else target
    md_files = sorted(notes_dir.glob("*.md"))

    if not md_files:
        print(f"  No .md files in {notes_dir}", file=sys.stderr)
        return [{"nodes": [], "edges": []}]

    all_filenames = {f.stem for f in md_files}
    nodes, edges = [], []

    for f in md_files:
        text = f.read_text(encoding="utf-8", errors="replace")
        # YAML first (block sequences, folded scalars); naive parser as fallback.
        fm = _safe_load_fm(text) or parse_frontmatter(text)
        body = extract_body(text)
        links = WIKILINK_RE.findall(body)

        node = {
            "id": f.stem,
            "label": f.stem.replace("-", " ").title(),
            "type": str(fm.get("type") or "unknown"),
            "domain": str(fm.get("domain") or "unknown"),
            "description": str(fm.get("description") or ""),
            "confidence": str(fm.get("confidence") or ""),
            "source_file": str(f.relative_to(target)),
        }
        topics = fm.get("topics") or []
        if isinstance(topics, list):
            topics = [str(t).replace("[[", "").replace("]]", "") for t in topics]
            node["topics"] = ", ".join(topics)
        else:
            node["topics"] = str(topics)
        nodes.append(node)

        for link in links:
            link_target = link.strip().lower().replace(" ", "-")
            if link_target in all_filenames:
                edges.append({
                    "source": f.stem,
                    "target": link_target,
                    "relation": "wiki_link",
                    "confidence_tag": "EXTRACTED",
                    "confidence": 1.0,
                })

    return [{"nodes": nodes, "edges": edges}]


def build_graph(extractions: list[dict]) -> nx.Graph:
    G = nx.Graph()
    for ext in extractions:
        for node in ext.get("nodes", []):
            nid = node.get("id", "")
            G.add_node(nid, **{k: v for k, v in node.items() if k != "id"})
        for edge in ext.get("edges", []):
            src, tgt = edge.get("source", ""), edge.get("target", "")
            G.add_edge(src, tgt, **{k: v for k, v in edge.items() if k not in ("source", "target")})
    return G


def get_hub_nodes(G: nx.Graph) -> set[str]:
    """Identify structural hub nodes to exclude from clustering.

    `bu` added for the workspace layer (DR-023 §8) — vault-only graphs have no
    type=bu nodes, so vault runs are unaffected (byte-stable).
    """
    return {n for n, d in G.nodes(data=True) if d.get("type") in ("moc", "bu")}


def detect_communities(G: nx.Graph, exclude_hubs: bool = True) -> dict[int, list[str]]:
    hubs = get_hub_nodes(G) if exclude_hubs else set()
    H = G.subgraph([n for n in G.nodes if n not in hubs]).copy()

    if H.number_of_nodes() == 0:
        G.graph["partitioner"] = "none"
        G.graph["partitioner_fallback"] = None
        return {}

    try:
        from graspologic.partition import leiden
        node_list = list(H.nodes)
        # graspologic takes `random_seed` (not `seed`) and, for an adjacency
        # matrix, returns {node_index: community_id}. The old `seed=` kwarg
        # raised TypeError and silently fell through to louvain every build.
        partition = leiden(nx.to_numpy_array(H, nodelist=node_list), random_seed=42)
        comms: dict[int, list[str]] = {}
        for idx, cid in sorted(partition.items()):
            comms.setdefault(int(cid), []).append(node_list[idx])
        G.graph["partitioner"] = "leiden"
        G.graph["partitioner_fallback"] = None
        return comms
    except ImportError:
        G.graph["partitioner_fallback"] = "graspologic is not installed"
    except Exception as exc:
        G.graph["partitioner_fallback"] = (
            f"graspologic leiden raised {type(exc).__name__}: {exc}"
        )

    try:
        communities_gen = nx.community.louvain_communities(H, seed=42)
        G.graph["partitioner"] = "louvain"
        return {i: list(c) for i, c in enumerate(communities_gen)}
    except Exception as exc:
        prev = G.graph.get("partitioner_fallback")
        G.graph["partitioner_fallback"] = (
            f"{prev}; louvain raised {type(exc).__name__}: {exc}" if prev
            else f"louvain raised {type(exc).__name__}: {exc}"
        )
        G.graph["partitioner"] = "connected-components"
        return {i: list(c) for i, c in enumerate(nx.connected_components(H))}


def find_god_nodes(G: nx.Graph, top_n: int = 10) -> list[dict]:
    hub_types = {"moc", "file", "bu"}
    candidates = [
        (n, d) for n, d in G.degree()
        if G.nodes[n].get("type", "") not in hub_types
    ]
    candidates.sort(key=lambda x: x[1], reverse=True)
    return [{"id": n, "degree": d, "label": G.nodes[n].get("label", n)} for n, d in candidates[:top_n]]


def find_surprising_connections(
    G: nx.Graph, communities: dict[int, list[str]],
    top_n: int = 15, max_per_node: int = 2,
) -> tuple[list[dict], int]:
    """Return (top rows, total cross-community edge count).

    Rows are ranked by degree sum; max_per_node greedily caps how many
    selected rows may share the same endpoint so god nodes cannot dominate
    (0 = no cap, pre-cap ordering).
    """
    hubs = get_hub_nodes(G)
    node_to_comm = {}
    for cid, members in communities.items():
        for m in members:
            node_to_comm[m] = cid

    cross_edges = []
    for u, v, data in G.edges(data=True):
        if u in hubs or v in hubs:
            continue
        cu, cv = node_to_comm.get(u, -1), node_to_comm.get(v, -1)
        if cu != cv and cu >= 0 and cv >= 0:
            cross_edges.append({
                "source": u, "target": v,
                "source_community": cu, "target_community": cv,
                "source_type": G.nodes[u].get("type", "?"),
                "target_type": G.nodes[v].get("type", "?"),
                "relation": data.get("relation", ""),
            })

    for e in cross_edges:
        e["score"] = G.degree(e["source"]) + G.degree(e["target"])
    cross_edges.sort(key=lambda x: x["score"], reverse=True)
    total = len(cross_edges)

    if max_per_node <= 0:
        return cross_edges[:top_n], total

    endpoint_count: dict[str, int] = {}
    selected = []
    for e in cross_edges:
        if (endpoint_count.get(e["source"], 0) >= max_per_node
                or endpoint_count.get(e["target"], 0) >= max_per_node):
            continue
        endpoint_count[e["source"]] = endpoint_count.get(e["source"], 0) + 1
        endpoint_count[e["target"]] = endpoint_count.get(e["target"], 0) + 1
        selected.append(e)
        if len(selected) >= top_n:
            break
    return selected, total


def compute_community_stats(G: nx.Graph, communities: dict[int, list[str]]) -> list[dict]:
    stats = []
    for cid, members in sorted(communities.items()):
        members = sorted(members)  # set-derived order is per-process; keep stats deterministic
        sub = G.subgraph(members)
        types = {}
        for m in members:
            t = G.nodes[m].get("type", G.nodes[m].get("domain", "unknown"))
            types[t] = types.get(t, 0) + 1
        primary = max(sorted(types), key=types.get) if types else "unknown"
        # Community ids are build-local (re-assigned every run). The anchor —
        # max-degree member, ties by id — is the stable label readers must cite.
        by_degree = sorted(members, key=lambda m: (-G.degree(m), m))
        stats.append({
            "id": cid, "size": len(members), "edges": sub.number_of_edges(),
            "primary_type": primary, "type_mix": types,
            "anchor": by_degree[0] if by_degree else None,
            "members_sample": by_degree[:5],
        })
    return stats
