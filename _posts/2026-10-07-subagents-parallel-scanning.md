---
title: "Subagents: Run Multiple Security Scans in Parallel"
date: 2026-10-07
tags: Multi-Agent & Workflows
layout: post
---

## The Tip

Claude Code can **fork itself** into parallel subagents — each running an independent task simultaneously. Use this to run Trivy, secret scanning, and dependency checks against a Docker image all at once instead of sequentially.

## Why This Matters

A full security scan pipeline (vulnerability scan + secret detection + SBOM generation + license check) takes 10+ minutes sequentially. With subagents, all four run in parallel — you get complete results in the time of the slowest single scan.

## Follow-Along: Parallel Image Audit

### The Prompt

```
Audit the Docker image snaplogic/groundplex:latest in parallel:
1. Fork an agent to run Trivy and summarize HIGH/CRITICAL CVEs
2. Fork an agent to run secret scanning with gitleaks on the image layers
3. Fork an agent to generate an SBOM with syft
Report all results when complete.
```

### What Happens

Claude launches three independent agents:

```
Agent 1 (trivy-scan)    → trivy image --severity HIGH,CRITICAL ...
Agent 2 (secret-scan)   → gitleaks detect --source /tmp/image-layers/
Agent 3 (sbom-generate) → syft snaplogic/groundplex:latest -o spdx-json
```

Each runs in its own context. When all three finish, Claude combines the results into a single report.

### The Output

```
Parallel scan complete for snaplogic/groundplex:latest:

Vulnerabilities: 12 HIGH, 3 CRITICAL (see trivy-results.json)
Secrets: 0 hardcoded credentials found
SBOM: 847 packages cataloged (spdx output saved)

Critical findings requiring immediate attention:
- CVE-2026-XXXX in libcurl (CRITICAL, EPSS 0.89)
- CVE-2026-YYYY in openssl (CRITICAL, EPSS 0.72)
```

## When to Use Subagents vs Sequential

| Use Subagents | Use Sequential |
|---|---|
| Scans are independent (no shared state) | Step 2 needs Step 1's output |
| You want fastest wall-clock time | You need to filter before the next scan |
| Each scan produces its own report | You're building one combined artifact |

## Practical Pattern: Pre-Deploy Gate

Before deploying a new Groundplex version:

```
Before I deploy, run these checks in parallel:
1. Trivy scan the new image for CVEs
2. Compare the SBOM against the previous version for new dependencies
3. Check if any CVEs from our last scan were fixed in this version
Block the deploy if any new CRITICAL CVEs appear.
```

## Key Takeaway

Subagents turn a 15-minute serial scan pipeline into a 5-minute parallel one. Think of them as background threads — each focused on one job, results collected at the end.
