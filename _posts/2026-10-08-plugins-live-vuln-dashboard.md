---
title: "Plugins: Build a Live Vulnerability Dashboard in Your Terminal"
date: 2026-10-08
tags: Plugins & UI
layout: post
---

## The Tip

Claude Code **plugins** let you add custom UI panes, status bars, and toasts directly inside the terminal. Build a live vulnerability counter that updates as you scan — no browser, no switching windows.

## Why This Matters

When you're running scans or processing CVE intakes, key metrics are buried in JSON files or Jira queries. A plugin surfaces them in real-time: current scan status, open CVE count, last scan date — always visible while you work.

## Follow-Along: Scan Status Bar

### Step 1 — Create the plugin

Save as `.claude/plugins/scan-status.js`:

```javascript
import { Band } from "claude-code/plugins";

export default {
  band: new Band({
    name: "scan-status",
    position: "bottom",
    render: async () => {
      // Read the latest scan results if they exist
      const fs = await import("fs/promises");
      try {
        const data = await fs.readFile("scan-results.json", "utf8");
        const results = JSON.parse(data);
        const critical = results.Results?.flatMap(r => r.Vulnerabilities || [])
          .filter(v => v.Severity === "CRITICAL").length || 0;
        const high = results.Results?.flatMap(r => r.Vulnerabilities || [])
          .filter(v => v.Severity === "HIGH").length || 0;
        return `Scan: ${critical} CRIT | ${high} HIGH | ${new Date().toLocaleTimeString()}`;
      } catch {
        return "No scan results loaded";
      }
    },
    refreshInterval: 10000, // Update every 10 seconds
  }),
};
```

### Step 2 — Register it

In `.claude/settings.json`:
```json
{
  "plugins": ["./plugins/scan-status.js"]
}
```

### Step 3 — See it in action

```bash
# Run a Trivy scan that outputs JSON
trivy image --format json --output scan-results.json \
  snaplogic/groundplex:latest

# The status bar at the bottom of Claude Code updates automatically:
# ┃ Scan: 3 CRIT | 12 HIGH | 2:34:15 PM ┃
```

## Toast Notifications

Want a pop-up when a Critical CVE is found? Add a toast:

```javascript
import { Toast } from "claude-code/plugins";

export const criticalAlert = new Toast({
  trigger: (event) => {
    if (event.type === "file-changed" && event.path === "scan-results.json") {
      const results = JSON.parse(event.content);
      const crits = results.Results?.flatMap(r => r.Vulnerabilities || [])
        .filter(v => v.Severity === "CRITICAL");
      if (crits.length > 0) {
        return { message: `${crits.length} CRITICAL CVEs found`, level: "error" };
      }
    }
  },
});
```

## Key Takeaway

Plugins turn Claude Code from a chat interface into a **security workstation**. Scan results, ticket counts, build status — all visible without switching context. Build what your dashboard doesn't show you.
