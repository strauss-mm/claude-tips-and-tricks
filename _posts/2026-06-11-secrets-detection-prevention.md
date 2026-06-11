---
title: "Secrets Detection: Find and Prevent Leaked Credentials"
date: 2026-06-11
tags: DevSecOps
layout: post
---

## The Tip

Use Claude Code to **audit your codebase for hardcoded secrets**, set up pre-commit detection, and implement the secrets management patterns that prevent leaks before they happen.

Hardcoded credentials are the #1 initial access vector in cloud breaches. Claude Code can scan for them, suggest fixes, and wire up automated prevention — all in one conversation.

## The Pattern

### 1. Instant Audit — Find Secrets Now

```
You: "Scan this repo for hardcoded secrets, API keys, tokens, 
      and credentials. Check config files, env files, test fixtures, 
      CI configs, and Dockerfiles. Report findings by severity."
```

Claude Code greps for patterns like:

```bash
# What Claude Code searches for
grep -rn --include="*.{py,js,ts,yaml,yml,json,tf,sh,env}" \
  -E "(AKIA[0-9A-Z]{16}|sk-[a-zA-Z0-9]{48}|ghp_[a-zA-Z0-9]{36}|xox[bpors]-)" .
```

### 2. Pre-Commit Hook with gitleaks

```
You: "Add gitleaks as a pre-commit hook so secrets can never 
      be committed. Use the Docker approach so it works on any machine."
```

Claude Code generates:

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.18.0
    hooks:
      - id: gitleaks
```

Install with:
```bash
pip install pre-commit && pre-commit install
```

### 3. Custom Rules for Your Stack

```
You: "Add custom gitleaks rules to detect SnapLogic slpropz files, 
      Wiz client secrets, and our internal API patterns."
```

```toml
# .gitleaks.toml
[[rules]]
id = "snaplogic-slpropz"
description = "SnapLogic configuration bundle"
regex = '''\.slpropz'''
path = '''(?i)(?:config|deploy|docker|script)'''

[[rules]]
id = "wiz-client-secret"
description = "Wiz API client secret"
regex = '''wiz[_-]?(?:client[_-]?)?secret\s*[=:]\s*['"]?[a-zA-Z0-9]{32,}'''

[allowlist]
paths = ['''\.gitleaks\.toml$''', '''test/fixtures/fake_creds\.py$''']
```

### 4. Replace Hardcoded Secrets with Proper Management

```
You: "This script has AWS keys hardcoded. Refactor it to use 
      AWS Secrets Manager with caching, and add the IAM policy 
      needed for the Lambda to access the secret."
```

Before (dangerous):
```python
AWS_KEY = "AKIAIOSFODNN7EXAMPLE"
AWS_SECRET = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
```

After (Claude Code generates):
```python
import boto3
from functools import lru_cache

@lru_cache(maxsize=1)
def _get_secrets():
    client = boto3.client("secretsmanager")
    resp = client.get_secret_value(SecretId="my-app/credentials")
    return json.loads(resp["SecretString"])
```

## DevSecOps Application

**Why this matters for security engineering:**

1. **IMDS Credential Theft** — Even with no hardcoded secrets, runtime credentials leak through SSRF → metadata service attacks (169.254.169.254). Detection tools find static secrets; you need architectural controls (IMDSv2 hop limit, VPC endpoints) for runtime ones.

2. **CI/CD Pipeline Secrets** — GitHub Actions secrets, Terraform variables, and Docker build args are common leak points. Scan `.github/workflows/`, `terraform.tfvars`, and `Dockerfile` specifically.

3. **Git History** — A secret removed in HEAD still lives in git history. Use:
   ```bash
   gitleaks detect --source . --log-opts="--all"
   ```

4. **Rotation + Detection Together** — Detecting a leak is step one. Pair with automated rotation:
   ```bash
   # After detection, rotate immediately
   aws secretsmanager rotate-secret --secret-id my-secret
   ```

5. **Shift Left** — Pre-commit hooks catch secrets before they enter version control. This is 1000x cheaper than detecting them in production logs or after a breach.

**The hierarchy of secrets defense:**
1. Pre-commit hooks (prevent)
2. CI pipeline scanning (detect)  
3. Runtime secret managers (manage)
4. Credential rotation automation (limit blast radius)
5. IMDS/network controls (prevent lateral movement)

## Try It Now

```
Ask Claude Code:
"Run gitleaks on this repo including full git history 
and show me any secrets that were ever committed, 
even if they've since been removed."
```

Or for a quick check:
```bash
# One-liner: scan current directory with Docker
docker run --rm -v "$(pwd):/src" zricethezav/gitleaks:latest detect --source /src
```
