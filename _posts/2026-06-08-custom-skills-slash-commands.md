---
title: "Custom Skills — Build Your Own Slash Commands"
date: 2026-06-19
tags: MCP & Tools
layout: post
---

## The Tip

Claude Code skills are reusable prompts triggered by `/command-name`. Instead of retyping complex workflows, encapsulate them as skills you invoke with a slash.

## Where Skills Live

Skills are markdown files in your project's `.claude/` directory:

```
.claude/commands/
├── security-review.md
├── scan-deps.md
├── deploy-check.md
└── incident-response.md
```

## Anatomy of a Skill

`.claude/commands/security-review.md`:
```markdown
---
description: Complete security review of pending changes on current branch
---

Review all pending changes on this branch for security vulnerabilities.

Check for:
1. Injection vulnerabilities (SQL, command, template, LDAP)
2. Authentication/authorization issues
3. Sensitive data exposure (logs, responses, error messages)
4. Missing input validation at trust boundaries
5. Cryptographic weaknesses (weak algorithms, hardcoded keys)
6. Race conditions and TOCTOU bugs
7. Deserialization vulnerabilities
8. Path traversal
9. SSRF potential
10. Dependency vulnerabilities (check lock files)

For each finding, output:
| Severity | Category | File:Line | Description | Remediation |

End with an overall risk assessment: SAFE / NEEDS FIXES / BLOCK DEPLOY
```

## Usage

Once created, just type:
```
/security-review
```

Claude executes the full prompt as if you typed it — but consistently, every time.

## Power Skills for DevSecOps

### `/threat-model`
```markdown
---
description: Generate a threat model for a service or feature
---

Generate a STRIDE threat model for the feature/service described 
in the current branch changes.

For each STRIDE category (Spoofing, Tampering, Repudiation, 
Information Disclosure, Denial of Service, Elevation of Privilege):

1. Identify relevant threats
2. Assess likelihood (High/Med/Low)
3. Assess impact (High/Med/Low)  
4. Suggest mitigations
5. Note which mitigations are already present in the code

Output as a structured table, then provide a summary paragraph 
suitable for a design review document.
```

### `/harden`
```markdown
---
description: Apply security hardening to the current code
---

Review the current codebase and apply security hardening:

1. Add input validation where missing
2. Ensure all SQL uses parameterized queries
3. Add rate limiting annotations to public endpoints
4. Ensure sensitive data is never logged
5. Add security headers to HTTP responses
6. Verify CORS configuration is restrictive
7. Check that error messages don't leak internals

Make the changes directly. For each change, add a brief inline 
comment only if the reason isn't obvious.
```

### `/pre-deploy`
```markdown
---
description: Pre-deployment security checklist
---

Run through the pre-deployment security checklist:

1. [ ] No secrets in code or config (search for API keys, passwords, tokens)
2. [ ] All dependencies at latest patch versions
3. [ ] No known CVEs in dependency tree (check advisories)
4. [ ] Docker image uses non-root user
5. [ ] Health check endpoint exists and doesn't expose internals
6. [ ] Logging configured (no PII in logs)
7. [ ] Error handling doesn't leak stack traces
8. [ ] HTTPS enforced, TLS 1.2+ only
9. [ ] Authentication required on all non-public endpoints
10. [ ] Resource limits configured (memory, CPU, connections)

Check each item against the actual code. Report pass/fail for each 
with evidence (file:line for passes, description for fails).
```

## Passing Arguments to Skills

Skills can accept input via `$ARGUMENTS`:
```markdown
---
description: Look up a CVE and assess impact on our stack
---

Look up $ARGUMENTS and determine:
1. What component is affected?
2. Do we use that component? (check dependencies)
3. What version are we on vs. the fix version?
4. What's the CVSS score and attack vector?
5. Is exploitation known in the wild?

Recommend: patch urgency and any immediate mitigations.
```

Usage: `/cve-lookup CVE-2024-21762`

## Pro Tip

Version control your skills in `.claude/commands/` — they're part of your project's security toolchain. Share them with your team via the repo. Each team member gets the same security workflows, consistently applied.
