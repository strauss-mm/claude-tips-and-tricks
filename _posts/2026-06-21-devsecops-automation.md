---
title: "DevSecOps Automation — Security as Code with Claude"
date: 2026-06-21
tags: DevSecOps
layout: post
---

## The Tip

DevSecOps means security is automated, not bolted on. Claude Code is your force multiplier — use it to build and maintain security automation that runs without you.

## Pattern 1: Infrastructure Security Scanning

Ask Claude to build Terraform security checks:
```
Write a pre-commit hook that runs tfsec on any changed .tf files 
and blocks the commit if there are HIGH or CRITICAL findings.
```

Or check live infrastructure:
```
Query our AWS account for:
- S3 buckets without encryption
- Security groups with 0.0.0.0/0 ingress
- IAM users with access keys older than 90 days
- Lambda functions not in a VPC

Output as a remediation checklist.
```

## Pattern 2: Container Hardening Pipeline

```
Review this Dockerfile for security issues:
1. Is it running as root?
2. Are there unnecessary packages installed?
3. Is the base image pinned to a digest?
4. Are secrets passed as build args?
5. Is there a .dockerignore preventing secret leakage?
6. Are there unnecessary COPY statements?
7. Multi-stage build to minimize attack surface?

Fix all issues and explain each change.
```

## Pattern 3: CI/CD Security Gates

Ask Claude to create GitHub Actions that enforce security:
```
Create a GitHub Actions workflow that:
1. Runs Trivy on the container image
2. Runs Semgrep with p/security-audit rules
3. Checks for dependency CVEs with pip-audit
4. Fails the build if any CRITICAL findings exist
5. Posts a summary comment on the PR

Use SARIF format where possible for GitHub Security tab integration.
```

## Pattern 4: Secrets Management Automation

```
Audit this codebase for secrets management:
1. Find all places where secrets are loaded
2. Check if they use AWS Secrets Manager / env vars / hardcoded
3. Create a migration plan to move any env var secrets to 
   AWS Secrets Manager
4. Generate the Terraform for the new secrets
5. Update the application code to use the SDK
```

## Pattern 5: Compliance as Code

```
Generate OPA (Open Policy Agent) policies that enforce:
1. All containers must have resource limits
2. No pods can run as root
3. All services must have network policies
4. All images must come from our private ECR
5. No hostPath volumes allowed

Output as .rego files with tests.
```

## Pattern 6: Incident Response Automation

```
Create a script that, given a compromised IAM access key:
1. Immediately deactivates the key
2. Lists all actions performed with that key (CloudTrail)
3. Identifies resources accessed/modified
4. Creates a timeline of events
5. Generates an incident report

Use boto3, output to markdown.
```

## Building Your Security Toolchain

Over time, use Claude to build:
- **Scanning pipelines** — automated Trivy/Semgrep/pip-audit
- **Policy engines** — OPA/Kyverno policies for K8s
- **Compliance checks** — CIS benchmarks automated
- **Alerting** — custom detections for your threat model
- **Reporting** — automated security posture dashboards

Each piece becomes a script or skill you can trigger anytime.

## Pro Tip

Don't just scan — **remediate**. Instead of "find vulnerabilities," say "find vulnerabilities AND fix them." Claude can apply patches, update dependencies, and modify configurations in a single pass. Review the changes, then commit. What used to take a sprint takes an afternoon.
