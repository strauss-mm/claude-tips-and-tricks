---
title: "Custom Skills: Package Repeatable Security Workflows"
date: 2026-10-11
tags: Skills & Slash Commands
layout: post
---

## The Tip

Claude Code **skills** (slash commands) let you package multi-step workflows into a single reusable command. Type `/scan-image` and Claude runs your entire scan-enrich-triage-report pipeline — same steps, same quality, every time.

## Why This Matters

Security workflows have strict steps that must be followed consistently. A vulnerability scan isn't just "run Trivy" — it's scan, deduplicate against Jira, enrich with NVD data, classify responsibility, create tickets, and post a summary. Skills encode all of that so no step gets skipped.

## Follow-Along: Build a `/scan-image` Skill

### Step 1 — Create the skill file

Save as `.claude/commands/scan-image.md`:

```markdown
---
description: Scan a Docker image for vulnerabilities and report findings
---

Scan the Docker image provided in $ARGUMENTS using this workflow:

1. Run Trivy against the image with JSON output
2. Parse results and group by severity (CRITICAL, HIGH, MEDIUM, LOW)
3. For each CRITICAL and HIGH finding:
   - Look up the CVE in NVD for CVSS score and exploitability
   - Search Jira to check if a ticket already exists
4. Generate a summary table:
   | CVE | Package | Severity | CVSS | EPSS | Jira Status |
5. Report:
   - Total findings by severity
   - New findings (no Jira ticket)
   - Already tracked findings
6. Save the full report to ~/dev/snaplex-reports/
```

### Step 2 — Use it

```
/scan-image snaplogic/groundplex:latest
```

Claude executes the entire workflow. Every time. Same order, same checks, same output format.

### Step 3 — Iterate and improve

Found a gap? Edit the skill file. Next run includes the fix. Skills are just markdown — version them in git, share with your team.

## Skill Design Patterns

### Parameterized skills
```markdown
Scan $ARGUMENTS with severity threshold HIGH.
If "full" is in arguments, include MEDIUM and LOW.
```

### Skills that call other skills
```markdown
1. Run the vulnerability scan workflow
2. If new CRITICAL findings, compose an alert email
3. Post summary to the #security Slack channel
```

### Pre-flight validation
```markdown
Before scanning:
- Verify the image exists in the registry
- Check that Trivy is installed and updated
- Confirm Jira credentials are configured
If any check fails, report what's missing and stop.
```

## Real Examples

| Skill | What It Automates |
|---|---|
| `/scan-image` | Full vulnerability scan pipeline |
| `/cve-intake` | Process customer vulnerability reports |
| `/check-bitsight` | Pull and triage BitSight findings |
| `/vendor-review` | Security assessment of a third-party vendor |
| `/triage-meeting` | Generate pre-meeting vulnerability summary |

## Key Takeaway

Skills are **runbooks that execute themselves**. Write the workflow once in markdown, invoke it with a slash command. Consistent execution, no steps forgotten, easy to improve over time.
