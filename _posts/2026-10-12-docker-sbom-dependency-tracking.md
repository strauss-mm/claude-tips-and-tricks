---
title: "Follow-Along: SBOM Your Docker Image and Track Every Dependency"
date: 2026-10-12
tags: Docker & Supply Chain
layout: post
---

## The Tip

Generate a Software Bill of Materials (SBOM) from your Docker image, then use Claude Code to analyze it — find outdated packages, flag known-vulnerable libraries, and track dependency changes across versions.

## Why This Matters

You can't secure what you can't see. A Groundplex image contains hundreds of packages — OS libraries, Java JARs, transitive Maven dependencies. An SBOM makes the invisible visible, and Claude turns that inventory into actionable intelligence.

## Follow-Along: Full SBOM Workflow

### Step 1 — Generate the SBOM

```
You: "Generate an SBOM for snaplogic/groundplex:latest 
using Syft in SPDX JSON format."
```

Claude runs:
```bash
syft snaplogic/groundplex:latest -o spdx-json > groundplex-sbom.json
```

### Step 2 — Analyze the inventory

```
You: "How many packages are in this SBOM? Break down by type 
(OS, Java, Python). Which packages are oldest by version?"
```

Claude parses the SBOM and reports:
```
Total packages: 847
- OS (apk/deb): 124
- Java (JAR): 689
- Python: 34

Oldest packages (by publish date):
1. commons-collections 3.2.2 (2015) — known deserialization risk
2. log4j-api 2.17.1 (2021) — patched but aging
3. jackson-databind 2.13.4 (2022)
```

### Step 3 — Cross-reference with vulnerability data

```
You: "Cross-reference this SBOM against the Trivy scan results 
at scan-results.json. Which packages in the SBOM have known CVEs?"
```

Claude joins the two datasets:

| Package | Version | CVE Count | Highest Severity |
|---------|---------|-----------|-----------------|
| libcurl | 7.88.1 | 3 | CRITICAL |
| openssl | 3.0.8 | 2 | HIGH |
| netty | 4.1.86 | 1 | HIGH |

### Step 4 — Track changes between versions

```
You: "I have the previous SBOM at groundplex-sbom-prev.json. 
What packages were added, removed, or changed version?"
```

```
Added (12 packages):
+ spring-security-core 6.1.2
+ snakeyaml 2.0

Removed (3 packages):
- log4j-core 2.17.1 (good — direct dependency removed)

Updated (28 packages):
↑ jackson-databind 2.13.4 → 2.15.2
↑ netty-handler 4.1.86 → 4.1.94
```

## Automating SBOM Diffs

Pair this with a hook or skill to auto-diff SBOMs on every new image build:

```
/scan-image myapp:v2.1 --sbom-diff myapp:v2.0
```

## Key Takeaway

An SBOM is your **dependency inventory**. Paired with vulnerability scans, it answers: what do we ship, what's vulnerable, and what changed since last time. Claude Code makes this analysis conversational instead of scripted.
