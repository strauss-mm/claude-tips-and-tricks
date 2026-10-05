---
title: "Follow-Along: Harden a Docker Image With Claude Code"
date: 2026-10-09
tags: Docker & Hardening
layout: post
---

## The Tip

Walk through a real hardening workflow: pull a Docker image, scan it, fix the findings, re-scan, and verify — all driven by Claude Code prompts. This is the security feedback loop in practice.

## The Scenario

You have a Dockerfile for a Java-based service. It works, but it hasn't been audited. Let's fix that.

## Step 1 — Start With a Baseline Scan

```
You: "Pull the base image eclipse-temurin:17-jre and run a 
Trivy scan. Show me HIGH and CRITICAL findings only."
```

Claude runs:
```bash
docker pull eclipse-temurin:17-jre
trivy image --severity HIGH,CRITICAL eclipse-temurin:17-jre
```

Typical output: 8 HIGH, 2 CRITICAL — mostly in OS packages from the Debian base.

## Step 2 — Switch to a Minimal Base

```
You: "Rewrite my Dockerfile to use eclipse-temurin:17-jre-alpine 
instead. Keep the same COPY and ENTRYPOINT."
```

Claude rewrites the Dockerfile, switching from Debian to Alpine. Fewer packages = smaller attack surface.

## Step 3 — Re-Scan and Compare

```
You: "Build the new image as myapp:hardened and scan it. 
Compare against the original."
```

```bash
docker build -t myapp:hardened .
trivy image --severity HIGH,CRITICAL myapp:hardened
```

Result: 1 HIGH, 0 CRITICAL. That's a 90% reduction from switching base images alone.

## Step 4 — Add Runtime Protections

```
You: "Add these hardening layers to my Dockerfile:
- Run as non-root user
- Drop all capabilities
- Read-only filesystem
- No new privileges"
```

Claude adds:

```dockerfile
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# At runtime (docker run):
# --cap-drop=ALL --read-only --security-opt=no-new-privileges
```

## Step 5 — Final Scan + Report

```
You: "Run a final Trivy scan on myapp:hardened and generate 
a before/after comparison as a markdown table."
```

| Metric | Before | After |
|--------|--------|-------|
| Base image | eclipse-temurin:17-jre | eclipse-temurin:17-jre-alpine |
| Image size | 287 MB | 178 MB |
| CRITICAL CVEs | 2 | 0 |
| HIGH CVEs | 8 | 1 |
| Runs as root | Yes | No |
| Capabilities | All | None |

## The Complete Workflow

```
Pull image → Scan → Identify fixes → Apply → Re-scan → Verify → Ship
```

Each step is one Claude prompt. The entire hardening cycle takes under 10 minutes — and you have a paper trail of every decision in your conversation history.

## Key Takeaway

Docker hardening isn't a one-time checklist — it's a **feedback loop**. Scan, fix, re-scan. Claude Code makes the loop fast enough to run on every change, not just before releases.
