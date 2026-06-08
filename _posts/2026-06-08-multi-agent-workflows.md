---
title: "Multi-Agent Workflows — Divide and Conquer"
date: 2026-06-16
tags: Advanced Patterns
layout: post
---

## The Tip

Claude Code can spawn **subagents** — independent Claude instances that work on subtasks without consuming your main context window. This is like having a team of specialists you can dispatch.

## How It Works

When you ask Claude to do broad research or parallel tasks, it can launch agents that:
- Have their own context window (don't pollute yours)
- Can work in parallel (multiple agents simultaneously)
- Return only summaries (you get signal, not noise)
- Can work in isolated git worktrees (safe experimentation)

## Triggering Multi-Agent Patterns

**Explicit:**
```
Search the entire codebase for hardcoded credentials, API keys, 
and connection strings. Check every file type. Report back with 
file paths and line numbers only.
```

**Parallel research:**
```
I need to understand three things simultaneously:
1. How authentication works in this project
2. What database migrations exist and their current state
3. What CI/CD pipeline is configured

Research all three in parallel and give me a brief summary of each.
```

**Isolated experimentation:**
```
In a separate worktree, try refactoring the auth middleware to use 
the new pattern. Don't touch my working tree — I want to review 
your approach before merging it.
```

## Advanced: The Explore Agent

For broad codebase questions, Claude uses a specialized "Explore" agent that's optimized for fast searching:

```
Find all places where we handle file uploads. I need to know:
- Which endpoints accept files
- What validation is done
- Where files are stored
- Any size limits configured
```

The Explore agent rapidly searches across files and returns a focused summary.

## DevSecOps Power Patterns

### Security Audit Sweep
```
Audit this codebase for OWASP Top 10 vulnerabilities. 
Check each category in parallel:
1. Injection (SQL, command, LDAP)
2. Broken authentication
3. Sensitive data exposure
4. XXE
5. Broken access control

For each, report: file, line, severity, and recommended fix.
```

### Dependency Risk Assessment
```
For each dependency in requirements.txt:
1. Check if it's actively maintained (last commit date)
2. Look for known CVEs
3. Check if we're on the latest version
4. Flag any that are deprecated

Research them in parallel — there are 40+ packages.
```

## Pro Tips

1. **Be explicit about parallelism** — say "in parallel" or "simultaneously" to ensure multiple agents launch
2. **Scope the return** — "report back with just X" prevents agents from dumping full file contents
3. **Use worktrees for risky experiments** — "in an isolated worktree, try..." keeps your working directory clean
4. **Chain agents** — "first research X, then based on findings, implement Y" for complex multi-step work
