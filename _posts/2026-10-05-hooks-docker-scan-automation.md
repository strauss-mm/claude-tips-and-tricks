---
title: "Hooks: Auto-Scan Docker Images on Every Build"
date: 2026-10-05
tags: Hooks & Automation
layout: post
---

## The Tip

Claude Code **hooks** are shell commands that fire automatically before or after tool calls. Wire one up to scan your Docker image for vulnerabilities every time Claude builds or modifies a Dockerfile — zero manual steps.

## Why This Matters

You're iterating on a Dockerfile, asking Claude to add packages or change the base image. Without hooks, you'd need to remember to scan after every change. With hooks, the scan runs automatically — you catch a new Critical CVE the moment it enters your image.

## Follow-Along: Trivy Scan Hook

### Step 1 — Create the hook script

Save this as `hooks/post-docker-scan.sh`:

```bash
#!/bin/bash
# Runs Trivy against the most recently built Docker image
IMAGE=$(docker images --format '{{.Repository}}:{{.Tag}}' | head -1)
if [ -z "$IMAGE" ]; then
  echo "No Docker image found to scan"
  exit 0
fi

echo "Scanning $IMAGE with Trivy..."
trivy image --severity HIGH,CRITICAL --format table "$IMAGE"
```

```bash
chmod +x hooks/post-docker-scan.sh
```

### Step 2 — Register the hook in settings

Add to `.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "if echo \"$TOOL_INPUT\" | grep -q 'docker build'; then ./hooks/post-docker-scan.sh; fi"
          }
        ]
      }
    ]
  }
}
```

### Step 3 — Try it

```
You: "Build this Dockerfile and tag it myapp:latest"
```

Claude runs `docker build` → the hook fires → Trivy scan results appear inline. If Critical CVEs show up, you see them immediately and can ask Claude to fix the base image or pin a patched version.

## Practical Application: Groundplex Image

```bash
# Pull a Groundplex image and scan it in one shot
docker pull snaplogic/groundplex:latest
trivy image --severity HIGH,CRITICAL snaplogic/groundplex:latest
```

Wire the hook to fire on any `docker pull` too — so every image entering your local environment gets scanned automatically.

## Key Takeaway

Hooks turn Claude Code into a **policy enforcement layer**. Every Docker build, every pull, every Dockerfile edit — automatically validated against your security baseline. No discipline required, just wiring.
