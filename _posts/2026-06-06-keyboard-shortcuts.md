---
title: "Keyboard Shortcuts That Save Hours"
date: 2026-06-14
tags: Shortcuts & Speed
layout: post
---

## The Tip

These keyboard shortcuts work in Claude Code CLI and save significant time:

| Shortcut | Action |
|----------|--------|
| `Escape` | Cancel current generation — stop Claude mid-response |
| `Ctrl+C` | Cancel and clear current input |
| `Up arrow` | Cycle through prompt history |
| `Ctrl+L` | Clear the screen (keep conversation) |
| `Tab` | Accept autocomplete suggestion |
| `!` prefix | Run a shell command inline (e.g., `! git status`) |

## The `!` Prefix — Hidden Power

Type `! <command>` at the Claude prompt to run a shell command whose output lands directly in the conversation:

```
! kubectl get pods -n security
```

Claude sees the output and can reason about it immediately — no copy-paste needed.

## Multi-line Input

For complex prompts, use `Shift+Enter` to add newlines without submitting. Structure your prompt with clear sections:

```
Review this terraform plan for security issues:
- Check IAM permissions (least privilege)
- Check network exposure (public access)
- Check encryption (at rest and in transit)

Focus on CRITICAL and HIGH only.
```

## DevSecOps Speed Hack

Create shell aliases that pair with Claude:

```bash
alias csc='claude "review the last git commit for security issues"'
alias ctf='claude "check this terraform file for misconfigurations" <'
alias csr='claude "/security-review"'
```

Now one keystroke gets you a security review.

## Pro Tip

Use `Escape` aggressively. If Claude starts down the wrong path (wrong file, misunderstood intent), hit Escape immediately and rephrase. Don't wait for a bad response — interrupt and redirect.
