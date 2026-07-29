# homebrew-plugmem

A [Homebrew](https://brew.sh) **tap** (third-party package repository) for
[plugmem](https://github.com/m62624/plugmem). It ships prebuilt binaries for
macOS and Linux, updated automatically by plugmem's release pipeline — you do
not build from source.

> ⚠️ Experimental. plugmem is mostly an AI-built experiment. Expect rough
> edges, broken behavior, or mistakes. Use it at your own risk.

> This repo only contains packaging. The source code, docs and issue tracker
> live in the [main plugmem repository](https://github.com/m62624/plugmem).

## What's in the tap

| Formula       | Installs binary | Purpose                                              |
| ------------- | --------------- | --------------------------------------------------- |
| `plugmem-cli` | `plugmem-cli`   | Command-line memory over one local file.            |
| `plugmem-mcp` | `plugmem-mcp`   | MCP stdio server exposing the memory to AI agents.  |

## CLI or MCP — which one?

These are two different doors, not two ways to do the same thing — pick by
**who is calling**:

- **`plugmem-cli`** — the **human / scripting** door. Use it from a terminal or
  a shell script: `plugmem-cli --db <file> remember "…"`,
  `plugmem-cli --db <file> recall "…"`. `plugmem-cli repl` keeps the engine
  open for host speed.
- **`plugmem-mcp`** — the **AI-agent** door. A long-lived stdio JSON-RPC server
  exposing the `plugmem_*` tools to an agent whose harness speaks MCP.

Not shipped through Homebrew: to embed a memory **inside a Rust program** use
the `plugmem-host` library, and **inside Node.js** install the `plugmem` addon
from npm. See the [main repository](https://github.com/m62624/plugmem).

## Install

First add the tap (once), then install whichever formula you need:

```bash
brew tap m62624/plugmem

# CLI — provides the `plugmem-cli` command
brew install m62624/plugmem/plugmem-cli

# MCP server — provides the `plugmem-mcp` command
brew install m62624/plugmem/plugmem-mcp
```

Once the tap is added you can use the short names too: `brew install plugmem-cli`.

Verify and upgrade:

```bash
plugmem-cli --version
brew upgrade m62624/plugmem/plugmem-cli
```

Uninstall / remove the tap:

```bash
brew uninstall plugmem-cli plugmem-mcp
brew untap m62624/plugmem
```

Supported platforms: macOS (Apple Silicon & Intel) and Linux (arm64 & x86_64).
Windows binaries ship on the [Releases page](https://github.com/m62624/plugmem/releases)
(installer script or `.msi`), not through Homebrew.

## What is plugmem?

An embeddable **memory database for local LLM agents** — think SQLite, but for
what an agent remembers rather than rows and columns. It stores short facts
(with a subject entity, tags, optional metadata, an optional embedding and two
time axes) and answers a query with a ranked, token-budgeted block ready to
paste into a prompt. One process, one file, no server.

See the [main repository](https://github.com/m62624/plugmem) for the design,
usage and the Claude Code skill.

## License

MIT — see the formula files and the [main repository](https://github.com/m62624/plugmem).
