---
title: "CLAUDE.md Mastery — Your Project's Brain"
date: 2026-06-15
tags: Advanced Patterns
layout: post
---

## The Tip

CLAUDE.md isn't just documentation — it's an **instruction set** that fundamentally changes how Claude operates in your project. Master it and every session starts at 100% effectiveness.

## The Architecture

Claude loads CLAUDE.md files in a hierarchy:

```
~/.claude/CLAUDE.md              → Global (all projects)
~/dev/CLAUDE.md                  → Workspace-wide
~/dev/my-project/CLAUDE.md       → Project-specific
~/dev/my-project/src/CLAUDE.md   → Directory-specific
```

Lower files override higher ones. Use this to set global preferences once and project-specific patterns per repo.

## What Goes Where

**Global (~/.claude/CLAUDE.md):**
```markdown
## Preferences
- Always use TypeScript strict mode
- Prefer functional patterns over classes
- Run tests before committing
- Never commit .env files
```

**Project-level:**
```markdown
## Commands
- Build: `make build`
- Test: `pytest -x --tb=short`
- Lint: `ruff check . --fix`

## Architecture
- src/api/ — FastAPI routes, one file per domain
- src/services/ — Business logic, never import from api/
- src/models/ — SQLAlchemy models

## Patterns
- All endpoints return ApiResponse[T] wrapper
- Use dependency injection via FastAPI Depends()
- Errors raise HTTPException, never return error dicts
```

## Power Techniques

### 1. Encode Team Decisions
```markdown
## Decisions
- We chose PostgreSQL over DynamoDB (need joins for reporting)
- Auth uses OIDC via Okta, not custom JWT
- All dates stored as UTC, displayed in user's timezone
```

### 2. Prevent Repeated Mistakes
```markdown
## Gotchas
- The `users` table has a soft-delete column — always filter `deleted_at IS NULL`
- Never call the payment API in tests — use the mock in tests/fixtures/
- Port 8080 is used by the local proxy; dev server must use 8081
```

### 3. Define Quality Gates
```markdown
## Before Committing
1. `ruff check . --fix && ruff format .`
2. `mypy src/ --strict`
3. `pytest -x`
4. No TODO comments without a ticket number
```

## DevSecOps Application

```markdown
## Security Requirements
- All user input sanitized through `src/utils/sanitize.py`
- SQL queries MUST use parameterized statements
- Secrets loaded from AWS Secrets Manager, never env vars in production
- All API endpoints require authentication except /health and /docs
- Container images scanned with Trivy before deployment
- Dependencies pinned with hashes in requirements.txt
```

## Pro Tip

Run `/init` to auto-generate a CLAUDE.md, then **edit it heavily**. The auto-generated version captures structure; you add the judgment, decisions, and tribal knowledge that makes Claude truly effective in your codebase.
