---
name: vault-graph
trigger: /vault-graph
description: >
  지식그래프 빌드·분석·질의 스킬. vault 그래프와 workspace 레이어는 `vmem graph build`가,
  코드 AST 그래프는 graphify CLI(`graphify update`)가 빌드한다. 커뮤니티 탐지, god node 분석, surprising connections, graphify MCP serve
  안내를 제공한다.
---

# /vault-graph [command]

> Before the first vmem call, read `lib/vault_adapter.md` §Runtime Discovery and bind the vmem vault id for the workspace `vault.path`; pass it as `vault` on every vmem tool call and as the `<vault>` argument of every `vmem` CLI command.

Knowledge graph build, query, report, and Graphify MCP setup for vault notes and code repos.

`vault-graph` owns the graph workflow.

## Shared Runtime

| Item | Path |
|------|------|
| Vault/workspace builder | `vmem graph build <vault> [--workspace]` (MCP `vmem_graph_build`) |
| Code builder | `~/.local/bin/graphify update <path>` (graphify CLI, absolute path) |
| Python | `~/.maru/env/.venv/bin/python` |
| Skill runner (graphify query) | `~/.maru/skills/vault-graph/scripts/run.sh` |
| graphifyignore template | `<workspace-root>/_meta/templates/graphifyignore` |

## Commands

### Query Commands (ripgrep-based, always available)
- **orphans**: notes with no incoming links
- **hubs**: notes with most connections
- **domain [name]**: all notes in a domain
- **cross [domain1] [domain2]**: notes linking across domains
- **backlinks [note]**: all notes linking to a specific note
- **density**: connection density metrics
- **stale [days]**: notes not modified in N days

### Build Commands
- **build**: Run community detection + analysis pipeline. Outputs:
  - `vault/reports/vault-graph.json` (node-link JSON)
  - `vault/reports/graph-report-YYMMDD.md` (audit report; 구 리포트는 보존되고 `graph-trend.md`에 빌드마다 행 1개가 추가된다)
- **build --workspace**: Add the work operational layer → `vault/reports/workspace-graph.json` (vault-graph.json untouched; no report written). **온디맨드 전용** — 주간 리츄얼에서 제외(L11b 폐기, `_meta/rules/knowledge-graph-integration.md` §7). See below.
- **neighbors [note]**: 1-hop neighborhood + community of a note from `vault-graph.json` (jq, no build).
- **report**: Read the latest graph report (if < 7 days old)
- **communities**: List detected communities from latest build
- **surprises**: List cross-community surprising connections
- **god-nodes**: Show most-connected non-MOC nodes

## Build Process (`/vault-graph build`)

Options:
- `--vault`: build the vault graph
- `--workspace`: build the vault layer **plus** the work operational layer (DR-019 §2) → `workspace-graph.json`
- `--code <path>`: build a code repository graph
- `<target>`: a wiki vault directory takes the `--vault` route; any other directory takes `--code`

1. Execute:
   ```bash
   vmem graph build <vault>               # --vault (MCP: vmem_graph_build)
   vmem graph build <vault> --workspace   # --workspace (MCP: vmem_graph_build workspace: true)
   ~/.local/bin/graphify update <path>    # --code
   ```
   For code builds, ensure `<path>/.graphifyignore` exists first. If missing, offer to copy `<workspace-root>/_meta/templates/graphifyignore`.
2. Pipeline: read notes/code → extract graph → community detection → god node analysis → surprising connections → report. vmem uses deterministic label propagation (MOCs and business-unit hubs excluded). 커뮤니티 제목은 **anchor 노트**(degree 최대 멤버)로 붙고 정수 id는 "do not cite" 줄에만 남는다(빌드마다 재배정되므로 인용 금지, KG 규칙 §5.1).
3. Outputs:
   - vault: `<vault.path>/reports/vault-graph.json`, `<vault.path>/reports/graph-report-YYMMDD.md` (+ `graph-trend.md` 행 추가, 구 리포트 보존)
   - workspace: `<vault.path>/reports/workspace-graph.json` only (no report or trend row; the result lists the work counters)
   - code: `<path>/graphify-out/graph.json`, `<path>/graphify-out/GRAPH_REPORT.md`
4. vmem writes the vault and workspace outputs and records the GRAPH event itself; add no log line. A build reported as refused names the rule in its receipt; stop and report it.
   The weekly ritual is a **single** vault build, run by the workspace's weekly job (`--workspace` is on-demand only). Order: build → lint → vault push → work pointer bump.

## Neighbors Process (`/vault-graph neighbors <note>`)

1-hop neighborhood + community of a note, read directly from `vault-graph.json` (no rebuild, no new lib — DR-019 §4). Used by context-enrichment §3 Graph Neighborhood injection.

```bash
jq --arg id "<stem>" '{node: (.nodes[]|select(.id==$id)),
  neighbors: [(.edges // .links)[]|select(.source==$id or .target==$id)]}' \
  <vault.path>/reports/vault-graph.json
```

Report the node's `community`, its degree-ranked neighbors (≤10), and same-community co-members. If the graph is missing or its `graph-report` is > 7 days old, skip and surface the staleness (never block).

## Report Process (`/vault-graph report [target]`)

1. Resolve report directory:
   - vault: `<vault.path>/reports/graph-report-*.md`
   - code: `<target>/graphify-out/GRAPH_REPORT.md`
2. Select newest report and warn if older than 7 days.
3. Read vault and code reports through filesystem read (reports are machine-generated artifacts; vmem tools read notes).
4. Summarize overview, god nodes, top communities, surprising connections, and isolate count.

## Query Process (`/vault-graph query "<question>" [options]`)

Use graphify query against the selected `graph.json`.

```bash
~/.maru/skills/vault-graph/scripts/run.sh \
  -m graphify query "<question>" \
  --graph <graph.json> [--dfs] [--budget N]
```

Options:
- `--graph <path>`: override graph path
- `--dfs`: use DFS instead of BFS
- `--budget N`: token budget, default 2000

## Setup Process (`/vault-graph setup [path]`)

1. Resolve target path, default current directory.
2. If `.graphifyignore` is missing, copy:
   ```bash
   cp <workspace-root>/_meta/templates/graphifyignore <target>/.graphifyignore
   ```
3. Run `/vault-graph build --code <target>`.
4. For large projects, optionally add project graph MCP config.

## Serve Process (`/vault-graph serve [graph_path]`)

1. Resolve `graph.json`, default `<vault.path>/reports/vault-graph.json`.
2. If missing, run `/vault-graph build` first.
3. Print MCP config block:
   ```json
   {
     "<project-name>-graph": {
       "command": "~/.maru/env/.venv/bin/python",
       "args": ["-c", "from graphify.serve import serve; serve('<graph_path>')"]
     }
   }
   ```

## Query Process (legacy)
1. Parse query type and parameters
2. Use ripgrep to scan vault/notes/ for wiki links and frontmatter
3. Build in-memory graph representation
4. Execute query
5. Format results

## Integration

- `/vault-connect` Step 0 reads graph report for connection candidates
- `/vault-sync` checks graph report for unconnected surprising connections
- `/vault-lint` checks L11 (graph staleness > 7 days), L12 (island communities, reported by member list)
- `skill-mine` mines skill candidates with `vmem skills mine`, which uses the same deterministic Leiden communities
- `<workspace-root>/AGENTS.md` §"Vault-First" Graph Report shortcut: T2/T3 ops read report before full vault search
