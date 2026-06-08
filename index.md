---
layout: default
title: Claude Tips & Tricks
---

# Claude Tips & Tricks — Lunch & Learn

Daily tips for mastering Claude Code, prompt engineering, and DevSecOps workflows.

**Updated daily at 1pm PT** — new tips delivered via email and archived here.

---

## Categories

- **Shortcuts & Speed** — keyboard shortcuts, slash commands, faster workflows
- **Prompt Engineering** — better prompts for better results
- **DevSecOps** — security scanning, CI/CD, infrastructure as code
- **MCP & Tools** — building and using MCP servers, custom tools
- **Advanced Patterns** — multi-agent workflows, hooks, automation

---

## All Tips

{% assign sorted_tips = site.tips | sort: 'date' | reverse %}
{% for tip in sorted_tips %}
### [{{ tip.title }}]({{ tip.url | relative_url }})
*{{ tip.date | date: "%B %d, %Y" }}* — {{ tip.category }}

{{ tip.excerpt }}

---
{% endfor %}
