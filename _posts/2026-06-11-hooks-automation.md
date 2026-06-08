---
title: "Hooks — Automate Repetitive Workflows"
date: 2026-06-11
tags: Advanced Patterns
layout: post
---

## The Tip

Claude Code hooks let you run shell commands automatically in response to events — like git hooks, but for your AI assistant.

**Available hook events:**
- `PreToolUse` — before a tool runs (gate/validate)
- `PostToolUse` — after a tool completes (react/chain)
- `Notification` — when Claude wants your attention
- `Stop` — when Claude finishes a response

## Example: Auto-lint After Every Edit

In `.claude/settings.json`:
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "command": "eslint --fix $CLAUDE_FILE_PATH 2>/dev/null || true"
      }
    ]
  }
}
```

Every file Claude edits gets auto-linted. No more "can you fix the formatting" follow-ups.

## DevSecOps Power Move: Security Gate

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "command": "semgrep --config auto $CLAUDE_FILE_PATH --quiet"
      }
    ]
  }
}
```

Now every file Claude writes gets an instant security scan. Vulnerabilities are caught before they even hit git.

## Pro Tip

Use `PreToolUse` hooks to prevent dangerous operations:
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "command": "echo $CLAUDE_COMMAND | grep -q 'rm -rf' && exit 1 || exit 0"
      }
    ]
  }
}
```
