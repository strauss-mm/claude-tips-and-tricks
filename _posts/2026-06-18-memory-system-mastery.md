---
title: "Claude Code Memory — Build Your AI Knowledge Base"
date: 2026-06-18
tags: Advanced Patterns
layout: post
---

## The Tip

Claude Code has a persistent memory system that survives across sessions. Used well, it means Claude never asks you the same question twice and always knows your preferences.

## How Memory Works

Claude stores memories in `~/.claude/projects/<path>/memory/` as markdown files with YAML front matter. Each memory has:
- **Type:** user, feedback, project, reference
- **Name:** searchable slug
- **Description:** one-line summary for relevance matching

## Memory Types and When They Fire

### User Memories
Stored when Claude learns about YOU:
```
"I'm a security engineer focused on container security"
"I prefer Terraform over CloudFormation"
"I use Python 3.11+ for all new projects"
```

### Feedback Memories
Stored when you correct Claude or confirm an approach:
```
"Don't add type annotations to test files"
"Always use poetry, never pip directly"
"That concise format was perfect, keep doing that"
```

### Project Memories
Context about ongoing work:
```
"We're migrating from Jenkins to GitHub Actions by Q3"
"The auth rewrite is blocked on the SSO vendor"
```

### Reference Memories
Pointers to external resources:
```
"Security tickets are in Jira project ISEC"
"Architecture docs live in Confluence space SEC"
```

## Power Moves

### 1. Explicitly Train Claude
```
Remember: when I ask for Terraform, always use the AWS provider 
version ~> 5.0 and include tags { ManagedBy = "terraform", 
Team = "security" } on all resources.
```

### 2. Save Workflow Preferences
```
Remember: for code reviews, I want you to focus on security 
and correctness only. I don't care about style — our linter 
handles that. Never suggest renaming variables.
```

### 3. Capture Tribal Knowledge
```
Remember: the "legacy" auth service on port 9090 is NOT legacy — 
it handles all OAuth flows. The name is misleading. Don't suggest 
replacing it.
```

### 4. Build Context Over Time
Each session, Claude learns more. After a few weeks:
- It knows your codebase architecture
- It knows your team's conventions
- It knows which approaches you've rejected before
- It knows your tools, accounts, and environments

## Managing Memory

```
/memory              — view current memories
"Forget that I use Python 3.9"   — remove specific memory
"Update: we switched from poetry to uv"  — correct stale info
```

## DevSecOps Application

Train Claude for your security role:
```
Remember: our vulnerability SLA is Critical=15 days, High=30 days, 
Medium=90 days, Low=best-effort. Amazon has special 5-day SLA for 
Critical. Count calendar days from Jira creation date.
```

```
Remember: never create Jira tickets for OS-level CVEs — those are 
the customer's responsibility in our shared responsibility model.
```

```
Remember: Trivy scan results must include full filesystem paths 
including snap pack directories. Never show just the JAR filename.
```

Over time, Claude becomes your perfect security engineering assistant — it knows your policies, your tools, your team's patterns, and your personal preferences.

## Pro Tip

Periodically ask Claude "What do you remember about my project?" to audit its knowledge. Remove outdated memories and reinforce correct ones. Think of it as maintaining a knowledge base that happens to live inside your AI tool.
