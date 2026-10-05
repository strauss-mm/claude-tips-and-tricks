---
title: "/loop: Continuous Security Monitoring From Your Terminal"
date: 2026-10-06
tags: Automation & Monitoring
layout: post
---

## The Tip

The `/loop` command runs a task on a recurring interval — turning Claude Code into a lightweight monitoring agent. Use it to poll for new vulnerabilities, watch build pipelines, or track scan progress without leaving your terminal.

## Why This Matters

Security work involves a lot of waiting and checking: "Did the scan finish?" "Any new CVEs published for our dependencies?" "Did the deploy go through?" Instead of switching between tabs and dashboards, let Claude check for you on a schedule.

## Follow-Along: Watch a Docker Scan

### Scenario
You kicked off a long-running Trivy scan of a large image and want to know when it finishes and what it found.

### Step 1 — Start the scan in the background

```bash
trivy image --format json --output scan-results.json \
  snaplogic/groundplex:latest &
```

### Step 2 — Start the monitoring loop

```
/loop 60 Check if scan-results.json exists and has content. 
When it does, summarize the HIGH and CRITICAL findings 
and stop the loop.
```

Claude checks every 60 seconds. When the scan finishes, it reads the JSON, gives you a summary, and stops — no polling scripts, no watching the terminal.

## Advanced: CVE Watch Loop

Monitor for newly published CVEs affecting your stack:

```
/loop 300 Check NVD for any new CVEs published today affecting 
Spring Framework, Jackson Databind, or Netty. If you find any, 
check if they're in our Trivy scan results at scan-results.json 
and flag matches.
```

## Dynamic Pacing

Omit the interval and Claude self-paces — checking frequently when things are active, backing off when idle:

```
/loop Watch the Docker build log at build.log. 
Report errors immediately, summarize when complete.
```

## Practical Combinations

| Loop Command | Use Case |
|---|---|
| `/loop 120 Check docker ps for exited containers` | Catch crashed containers |
| `/loop 300 Scan for new HIGH CVEs in scan-results.json` | Vulnerability alerting |
| `/loop 60 Check if the ECS task is RUNNING` | Deploy monitoring |

## Key Takeaway

`/loop` replaces the "check on it in 5 minutes" mental burden. Set it, continue other work, get notified when something needs attention. Security monitoring shouldn't require browser tabs.
