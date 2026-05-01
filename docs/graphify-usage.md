# Graphify Usage

Build a knowledge graph from any markdown vault or code repo with `build-graph.py`. Output: NetworkX graph + a human-readable report (god nodes, communities, surprising connections).

> `build-graph.py` is not bundled with this catalog. Install [`graphifyy`](https://pypi.org/project/graphifyy/) and [`graspologic`](https://github.com/microsoft/graspologic) into a Python venv, and place a thin wrapper on disk. The shape of that wrapper is the same regardless of where it lives — it forwards `--target`, `--mode`, and `--out-dir` to `graphify`.

## Install

```bash
uv pip install graphifyy graspologic
```

## Run

```bash
PYTHON=/path/to/.venv/bin/python
SCRIPT=/path/to/build-graph.py

# Markdown vault (wiki-link graph)
$PYTHON $SCRIPT --target /path/to/vault --mode wiki

# Source repo (AST graph)
$PYTHON $SCRIPT --target /path/to/repo --mode code

# Auto-detect by content
$PYTHON $SCRIPT --target /path/to/anything
```

## Modes

|              | `wiki`                            | `code`                                  |
|--------------|-----------------------------------|------------------------------------------|
| Input        | Markdown notes                    | Source files                             |
| Extraction   | `[[wiki-link]]` parsing           | tree-sitter AST (22 languages)           |
| LLM required | No                                | No (AST is deterministic)                |
| Communities  | Leiden (MOC nodes excluded)       | Leiden                                   |
| Use case     | Surface knowledge clusters        | Surface module structure                 |

## Output

| File | Path | Purpose |
|------|------|---------|
| `graph.json` | `<target>/graphify-out/` (code) or `<vault>/reports/vault-graph.json` (wiki) | NetworkX `node_link` JSON |
| `graph-report-YYMMDD.md` | same | Human-readable report (god nodes, communities, surprises) |

## Apply to a new project

### 1. Drop in `.graphifyignore`

```
node_modules/
.venv/
dist/
build/
.next/
*.pdf
*.hwp
*.lock
package-lock.json
pnpm-lock.yaml
```

Tune for the project. Anything matched is skipped during graph build.

### 2. Build

```bash
$PYTHON $SCRIPT --target . --mode code
```

### 3. (Optional) Serve the graph as an MCP server

```bash
$PYTHON -c "from graphify.serve import serve; serve('./graphify-out/graph.json')"
```

Or register it permanently in `~/.claude/.mcp.json`:

```json
{
  "mcpServers": {
    "graphify-myproject": {
      "command": "/path/to/.venv/bin/python",
      "args": ["-c", "from graphify.serve import serve; serve('/abs/path/to/graph.json')"]
    }
  }
}
```

### 4. (Optional) Reference in `CLAUDE.md`

```markdown
## Graph Report

Before exploring the codebase, read `graphify-out/graph-report-YYMMDD.md`
for god nodes, community structure, and inter-module connections.
```

## MCP tools (when served)

| Tool | Description |
|------|-------------|
| `query_graph` | BFS/DFS exploration from a natural-language question |
| `get_node` | Detailed lookup for one node |
| `get_neighbors` | Adjacency list for a node |
| `shortest_path` | Path between two nodes |
| `god_nodes` | Most-connected nodes |
| `graph_stats` | Summary (nodes, edges, communities, density) |

## Vault integration

If you maintain a markdown vault, you can wire the graph report into a few skills:

- A `/connect` step that reads the report for connection candidates
- A `/lint` rule that flags reports older than 7 days
- A `/lint` rule that flags island communities (no cross-edges)
- A timeline file (e.g., `log.md`) appending a `GRAPH` event per build

These are pattern hooks rather than required wiring.
