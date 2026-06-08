---
title: "SBOM Generation & Supply Chain Security with Claude Code"
date: 2026-06-08
tags: DevSecOps
layout: post
---

## The Tip

Use Claude Code to generate, analyze, and act on **Software Bill of Materials (SBOMs)** — the foundation of supply chain security. Combine CLI tools with Claude's reasoning to go from "what's in my container?" to "what's exploitable?" in seconds.

## Generate SBOMs with One Command

```bash
# CycloneDX format (preferred for vulnerability correlation)
syft packages docker:myapp:latest -o cyclonedx-json > sbom.json

# SPDX format (preferred for license compliance)
syft packages docker:myapp:latest -o spdx-json > sbom-spdx.json

# Scan a directory (no Docker needed)
syft packages dir:/path/to/project -o cyclonedx-json > sbom.json
```

Then ask Claude to analyze it:

```
Analyze sbom.json — identify any packages older than 2 years,
any with known CVEs via the EPSS API, and flag any
copyleft licenses that conflict with our commercial use.
```

## Cross-Reference SBOMs Against Live Threat Intel

Build a skill that pipes SBOM contents through vulnerability databases:

```bash
# Extract package list from SBOM
jq -r '.components[] | "\(.name)@\(.version)"' sbom.json > packages.txt

# Bulk lookup against OSV (Google's open-source vulnerability DB)
while read pkg; do
  name=$(echo "$pkg" | cut -d@ -f1)
  version=$(echo "$pkg" | cut -d@ -f2)
  curl -s "https://api.osv.dev/v1/query" \
    -d "{\"package\":{\"name\":\"$name\",\"ecosystem\":\"Maven\"},\"version\":\"$version\"}" \
    | jq -r '.vulns[]?.id // empty'
done < packages.txt
```

## Diff SBOMs Between Releases

Track what changed between deployments:

```bash
# Generate SBOMs for both versions
syft packages docker:myapp:v1.0 -o cyclonedx-json > sbom-v1.json
syft packages docker:myapp:v2.0 -o cyclonedx-json > sbom-v2.json
```

Then prompt Claude:

```
Compare sbom-v1.json and sbom-v2.json. Show me:
1. New dependencies added (potential new attack surface)
2. Dependencies removed (potential breaking changes)
3. Version changes (check if any downgraded)
4. Any new packages from untrusted publishers
```

## Automate SBOM Attestation in CI/CD

```yaml
# GitHub Actions step
- name: Generate & Attest SBOM
  run: |
    syft packages . -o cyclonedx-json > sbom.json
    cosign attest --predicate sbom.json \
      --type cyclonedx \
      ${{ env.IMAGE_REF }}
```

## DevSecOps Application

### Real-World Workflow: Customer Vulnerability Intake

When a customer sends a vulnerability scan, cross-reference their findings against your SBOM:

```bash
# Customer says "you have CVE-2026-12345"
# Step 1: Check if the package is in our SBOM
jq -r '.components[] | select(.name | contains("affected-pkg"))' sbom.json

# Step 2: Check the full dependency path (is it direct or transitive?)
# Step 3: Determine responsibility (our code vs. OS-level vs. customer config)
```

### Supply Chain Attack Detection

Monitor for dependency confusion and typosquatting:

```
Review my sbom.json for supply chain risks:
1. Any packages with names similar to popular packages (typosquatting)?
2. Any packages published within the last 30 days (new/untrusted)?
3. Any packages pulling from multiple registries (dependency confusion)?
4. Any packages with abnormally low download counts for their age?
```

### Compliance: Executive Order 14028

US federal contracts now require SBOMs. Automate the requirement:

```bash
# Generate NTIA-minimum SBOM fields
syft packages . -o cyclonedx-json | jq '{
  supplier: .metadata.component.supplier,
  component_name: .metadata.component.name,
  version: .metadata.component.version,
  unique_identifiers: [.components[].purl],
  dependency_relationships: [.dependencies[]],
  timestamp: .metadata.timestamp
}'
```

## Pro Tip

Combine SBOM analysis with Claude Code's memory system: save your approved packages list to memory, then during intake reviews Claude automatically flags anything not on the allowlist. Your supply chain policy becomes a living, enforced standard — not a stale spreadsheet.
