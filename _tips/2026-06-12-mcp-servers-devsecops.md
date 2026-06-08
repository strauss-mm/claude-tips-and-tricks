---
title: "MCP Servers — Give Claude Superpowers"
date: 2026-06-12
category: MCP & Tools
---

## The Tip

MCP (Model Context Protocol) servers extend Claude Code with custom tools. Instead of copy-pasting output from other tools, connect them directly.

## What You Can Connect

- **Jira** — search/create/update tickets without leaving Claude
- **Slack** — post messages, read channels
- **AWS** — query resources, check configs
- **Custom scanners** — Trivy, Nuclei, Nmap results piped directly
- **Databases** — query without switching windows

## Quick Setup

In `.claude/settings.json`:
```json
{
  "mcpServers": {
    "my-scanner": {
      "command": "python",
      "args": ["-m", "my_mcp_server"],
      "env": {
        "API_KEY": "..."
      }
    }
  }
}
```

## DevSecOps Use Case: Vulnerability Pipeline

Build an MCP server that:
1. Accepts a CVE ID
2. Queries NVD for details
3. Checks your SBOM for affected packages
4. Searches Jira for existing tickets
5. Returns a structured recommendation

One prompt: "Check if CVE-2024-1234 affects us" — Claude does ALL of that automatically.

## Getting Started

The fastest path: look at existing MCP servers on GitHub. The `@anthropic-ai/sdk` package has TypeScript templates, and Python servers use the `mcp` package.

```bash
pip install mcp
# or
npm install @modelcontextprotocol/sdk
```

## Pro Tip

MCP servers can return structured data — not just text. Return JSON and Claude will reason over it more accurately than parsing free-text output.
