---
title: "Parallel Tool Calls — Do More in Less Time"
date: 2026-06-08
tags: Shortcuts & Speed
layout: post
---

## The Tip

When you ask Claude Code to do multiple independent things, it can run them **in parallel** — but only if you frame your request correctly.

**Instead of:**
```
Check git status
```
then
```
Run the tests
```

**Do this:**
```
Check git status and run the tests at the same time
```

Claude will execute both in a single round-trip, cutting your wait time in half.

## Why It Works

Claude Code can issue multiple tool calls simultaneously when there are no dependencies between them. The key is making it clear the tasks are independent.

## DevSecOps Application

When scanning infrastructure:
```
Run trivy on the container image AND check the terraform plan for security issues
```

Both scans are independent — running them in parallel saves minutes on every pipeline check.

## Pro Pattern

Combine with explicit parallelism words: "simultaneously", "at the same time", "in parallel", "concurrently". This signals to Claude that the tasks don't depend on each other.
