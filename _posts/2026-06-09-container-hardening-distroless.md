---
title: "Container Hardening: Distroless Builds & Attack Surface Reduction"
date: 2026-06-09
tags: DevSecOps
layout: post
---

## The Tip

Use Claude Code to convert bloated container images into **hardened, distroless builds** that slash your CVE surface by 80%+. A typical `python:3.11` image carries 400+ packages and hundreds of CVEs — a distroless or multi-stage slim build cuts that to near-zero OS-level vulnerabilities.

## The Problem

```bash
# Standard Python image — how many vulnerabilities?
trivy image python:3.11 --severity HIGH,CRITICAL -q
# Result: 47 HIGH, 12 CRITICAL (as of June 2026)

# Your app only needs Python + 3 pip packages
# Why ship bash, apt, curl, gcc, and 400 other binaries?
```

## Multi-Stage Distroless Pattern

Ask Claude Code to refactor any Dockerfile into a hardened multi-stage build:

```dockerfile
# Stage 1: Build dependencies in a full image
FROM python:3.11-slim AS builder

WORKDIR /build
COPY requirements.txt .
RUN pip install --no-cache-dir --target=/deps -r requirements.txt

# Stage 2: Runtime in distroless (no shell, no package manager, no attack surface)
FROM gcr.io/distroless/python3-debian12

WORKDIR /app
COPY --from=builder /deps /deps
COPY collectors/ .

ENV PYTHONPATH=/deps
USER nonroot:nonroot

ENTRYPOINT ["python", "-c"]
```

## Quick Hardening Checklist (Ask Claude to Verify)

Prompt Claude Code with:

```
Review my Dockerfile for container security:
1. Is it multi-stage? (build deps separate from runtime)
2. Does it run as non-root? (USER directive)
3. Are there unnecessary packages in the final stage?
4. Is .dockerignore blocking secrets (.env, .git, *.key)?
5. Are base image tags pinned (not :latest)?
6. Is HEALTHCHECK defined?
```

## Pin Base Images by Digest

```dockerfile
# BAD: mutable tag, could change under you
FROM python:3.11-slim

# GOOD: pinned digest, reproducible builds
FROM python:3.11-slim@sha256:abc123def456...

# Find the digest:
# docker inspect --format='{{index .RepoDigests 0}}' python:3.11-slim
```

## Scan Before and After

```bash
# Before hardening
trivy image myapp:before --severity HIGH,CRITICAL --format table

# After distroless refactor
trivy image myapp:after --severity HIGH,CRITICAL --format table

# Compare side-by-side with Claude
# "Compare these two Trivy scans and summarize what was eliminated"
```

## Runtime Security Constraints (K8s SecurityContext)

```yaml
# Add to your Pod spec for defense-in-depth
securityContext:
  runAsNonRoot: true
  runAsUser: 65534
  readOnlyRootFilesystem: true
  allowPrivilegeEscalation: false
  capabilities:
    drop: ["ALL"]
  seccompProfile:
    type: RuntimeDefault
```

Ask Claude: *"Add a SecurityContext to all pods in my Helm chart that enforces non-root, read-only filesystem, and drops all capabilities."*

## DevSecOps Application

**For your CTI Grafana Cloud collectors:**

The current `Dockerfile` uses `python:3.11-slim` (good start), but you can go further:

```bash
# Check your current attack surface
trivy image 179029418357.dkr.ecr.us-west-2.amazonaws.com/cti-collectors:latest

# Ask Claude to refactor to distroless
# "Refactor my Dockerfile to use gcr.io/distroless/python3-debian12 as the runtime stage"
```

**Impact on your vulnerability posture:**
- `python:3.11` → ~59 CVEs (HIGH+CRITICAL)
- `python:3.11-slim` → ~12 CVEs
- `distroless/python3` → 0-2 CVEs (only glibc/openssl)

This directly reduces the CVEs that show up in your Groundplex scans and customer intake reports — fewer OS-level findings means less noise and faster triage.

**Bonus — add to your CI pipeline:**

```bash
# Gate deployments on zero HIGH/CRITICAL in final image
trivy image $IMAGE --severity HIGH,CRITICAL --exit-code 1
```

## Try It Now

```
Ask Claude Code:
"Audit my Dockerfile at ./Dockerfile — is it using multi-stage builds?
What's my attack surface? Refactor it to use distroless and add
a SecurityContext to my K8s pod spec."
```

---

*Tomorrow: Zero Trust Network Policies in Kubernetes — restricting pod-to-pod traffic for defense in depth.*
