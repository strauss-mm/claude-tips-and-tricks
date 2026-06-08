---
title: "The Specificity Ladder — Level Up Your Prompts"
date: 2026-06-10
tags: Prompt Engineering
layout: post
---

## The Tip

Most people prompt at Level 1. Each level up gets dramatically better results:

**Level 1 — Vague:**
> "Fix the security issue"

**Level 2 — What:**
> "Fix the SQL injection in the login endpoint"

**Level 3 — What + Where:**
> "Fix the SQL injection in `src/auth/login.py` line 42 where user input goes directly into the query"

**Level 4 — What + Where + How:**
> "Fix the SQL injection in `src/auth/login.py` line 42 by using parameterized queries with the existing `db.execute()` helper, and add a test case"

**Level 5 — Full Context:**
> "Fix the SQL injection in `src/auth/login.py` line 42 by using parameterized queries. This is a FastAPI endpoint using asyncpg. Keep the existing error handling pattern from the other endpoints in that file. Add a pytest case to `tests/test_auth.py`."

## Why Level 4-5 Wins

Claude Code can figure things out — but every ambiguity is a coin flip. At Level 5, you remove ALL coin flips. The result matches your intent on the first try.

## The Rule of Thumb

If you'd spend more than 30 seconds explaining it to a colleague, spend those 30 seconds in the prompt. You'll save 5 minutes of back-and-forth.

## DevSecOps Application

For security reviews, always specify:
- The threat model ("assume untrusted input from...")
- The standard to check against ("OWASP Top 10", "CIS benchmark")
- What output format you want ("table with severity, finding, remediation")
