---
title: "Advanced Prompt Engineering for Claude Code"
date: 2026-06-17
tags: Prompt Engineering
layout: post
---

## The Tip

Move beyond basic prompts. These advanced patterns make Claude Code dramatically more effective for complex engineering work.

## Pattern 1: Constraint-First Prompting

Tell Claude what NOT to do before what to do. Constraints are more reliable than instructions.

```
DON'T:
- Modify any existing tests
- Change the public API signature
- Add new dependencies

DO:
- Fix the race condition in the connection pool
- Add internal locking mechanism
- Keep the fix backward-compatible
```

**Why it works:** Claude tends to over-help. Constraints prevent scope creep.

## Pattern 2: Role + Context + Task + Format

Structure complex prompts in four parts:

```
You're reviewing this code as a senior security engineer 
doing a pre-production audit. [ROLE]

This service handles PII for healthcare customers and must 
comply with HIPAA. It processes 10K requests/sec. [CONTEXT]

Review the authentication middleware for vulnerabilities. [TASK]

Output a table: | Finding | Severity | Line | Fix | [FORMAT]
```

## Pattern 3: Chain-of-Thought Steering

For complex analysis, explicitly request the reasoning process:

```
Analyze whether this Terraform change could cause downtime.
Think through:
1. What resources are being modified vs. replaced?
2. Are there any depends_on chains that force recreation?
3. What's the blast radius if the apply fails mid-way?
4. Is there a safe ordering for these changes?

Show your reasoning, then give me a yes/no on safety.
```

## Pattern 4: Few-Shot In-Context

Show Claude exactly what you want by example:

```
Add error handling to these functions following this pattern:

EXAMPLE (already done):
```python
async def get_user(user_id: str) -> User:
    try:
        return await db.users.find_one(user_id)
    except DatabaseError as e:
        logger.error("get_user failed", user_id=user_id, error=str(e))
        raise ServiceError(f"Failed to fetch user: {e}") from e
```

NOW apply the same pattern to: create_user, update_user, delete_user
```

## Pattern 5: Iterative Refinement

Don't try to get everything in one prompt. Use progressive enhancement:

```
Round 1: "Implement the basic CRUD endpoints for /api/scans"
Round 2: "Now add input validation using Pydantic models"
Round 3: "Add rate limiting — 100 req/min per API key"  
Round 4: "Add OpenAPI documentation with examples"
```

Each round builds on the previous, and you can course-correct between rounds.

## Pattern 6: Negative Examples

Show what you DON'T want:

```
Refactor this function. 

BAD (what I don't want):
- Splitting into 10 tiny functions that just call each other
- Adding a class hierarchy for what's currently a simple function
- Over-abstracting for hypothetical future requirements

GOOD (what I do want):
- Extract the validation into a reusable helper
- Keep the core logic in one readable function
- Use early returns instead of nested if/else
```

## DevSecOps Application

### Security Review Prompt Template
```
Security review this diff as if you're the last gate before production.

Context:
- This handles [payment/auth/PII] data
- Deployed to [AWS/GCP] with [describe access model]
- Threat model: [internet-facing / internal / service-to-service]

Check for:
1. Injection vectors (SQL, command, template)
2. Authentication/authorization bypass
3. Sensitive data in logs or responses
4. Missing input validation
5. Cryptographic weaknesses
6. Race conditions / TOCTOU

For each finding:
| Severity | Category | File:Line | Description | Fix |
```

## Pro Tip

Save your best prompts as Claude Code skills (custom slash commands). A prompt you've refined over 5 iterations is worth preserving — don't retype it every time.
