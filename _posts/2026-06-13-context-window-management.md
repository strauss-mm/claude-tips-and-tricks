---
title: "Context Window Mastery — Never Lose Your Place"
date: 2026-06-13
tags: Advanced Patterns
layout: post
---

## The Tip

Claude Code's context window is finite. How you manage it determines whether you get great results in long sessions or degraded output.

## The Signs You're Running Low

- Claude repeats suggestions it already made
- Responses become more generic
- It "forgets" files it read earlier in the session

## Strategies

### 1. Front-load Context with CLAUDE.md

Put your project's key patterns, commands, and architecture in `CLAUDE.md`. This is loaded automatically — it's "free" context that persists across sessions.

### 2. Use `/compact` Strategically

Don't wait until things break. After completing a major subtask, `/compact` to consolidate. Think of it as "saving your game."

### 3. Be Explicit About What Matters

```
Focus on src/auth/ — ignore the test files for now.
Only look at the Python files, skip the JS.
```

This prevents Claude from reading unnecessary files and wasting context.

### 4. Start Fresh for New Tasks

If you're switching from "fix the CI pipeline" to "review this PR" — start a new session. Leftover context from task A will degrade task B.

### 5. Use Subagents for Research

```
Search the codebase for all uses of the deprecated auth middleware.
Report back just the file paths and line numbers.
```

The subagent burns its own context window, and only the summary comes back to you.

## DevSecOps Application

When doing large security reviews, break it into focused sessions:
1. Session 1: Authentication & authorization
2. Session 2: Input validation & injection
3. Session 3: Cryptography & secrets management

Each session starts fresh with full context dedicated to one concern.
