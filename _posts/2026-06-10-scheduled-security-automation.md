---
title: "Scheduled Security Automation: From Cron to Cloud-Native"
date: 2026-06-10
tags: DevSecOps
layout: post
---

## The Tip

Use Claude Code to migrate local scheduled security tasks (crontabs, session-based jobs) into **cloud-native EventBridge Scheduler + Lambda/Fargate** infrastructure — fully defined in Terraform, version-controlled, and independent of any single machine.

The pattern: describe your scheduled jobs to Claude Code and let it generate the complete IaC stack — EventBridge rules, Lambda handlers, IAM roles, and notification plumbing — in one pass.

## The Pattern

```
You: "I have these cron jobs running locally:
      - Monthly vuln scan (2nd Tuesday 2pm)
      - BitSight findings check (Mon/Thu 9:23am)
      - Weekly CVD disclosure check (Mon 9:17am)
      
      Migrate them all to AWS EventBridge Scheduler with 
      Terraform. Scans should trigger ECS Fargate tasks, 
      lightweight checks should use Lambda."
```

Claude Code generates:

```hcl
# EventBridge Scheduler with timezone-aware cron
resource "aws_scheduler_schedule" "vuln_scan_monthly" {
  name       = "groundplex-monthly-scan"
  group_name = aws_scheduler_schedule_group.security.name

  flexible_time_window { mode = "OFF" }

  # 2nd Tuesday of each month at 2pm PT
  schedule_expression          = "cron(0 21 ? * 3#2 *)"
  schedule_expression_timezone = "America/Los_Angeles"

  target {
    arn      = aws_lambda_function.scheduled.arn
    role_arn = aws_iam_role.scheduler.arn
    input = jsonencode({
      action      = "groundplex_scan"
      environment = "emea-cp"
    })
  }
}

# One-shot schedules for release-aligned scans
resource "aws_scheduler_schedule" "release_scans" {
  for_each = local.release_dates  # Map of date → version

  schedule_expression = "at(${each.value.date})"
  # ...fires once, then auto-deletes
}
```

## Key Techniques

### 1. Separation of Concerns
- **EventBridge Scheduler** = when to run (cron/at expressions)
- **Lambda** = lightweight orchestration (API calls, Jira, email)
- **ECS Fargate** = heavy compute (scanning, report generation)

### 2. Self-Healing Scans
```python
# Lambda scales up ECS service → scanner runs → scanner scales back to 0
def handle_groundplex_scan(event):
    ecs_client.update_service(
        cluster=ECS_CLUSTER,
        service=f"groundplex-{event['environment']}",
        desiredCount=1,
    )
    # Scanner sidecar auto-scales to 0 when done
```

### 3. Failure Notifications
```python
# Wrap every scheduled handler with email-on-failure
try:
    return handler_fn(event)
except Exception as e:
    ses_client.send_email(
        Subject=f"Scheduled Task FAILED: {action}",
        Body=f"Error: {e}\nEvent: {json.dumps(event)}"
    )
    raise  # Still propagate for CloudWatch alarm
```

### 4. Ask Claude Code to Validate
```
You: "terraform validate this new scheduled-tasks.tf 
      and check the IAM permissions are least-privilege"
```

## DevSecOps Application

**Why this matters for security engineering:**

1. **Reliability** — Security scans that depend on a laptop being open will be skipped. Cloud-native schedules run regardless of machine state, vacations, or power outages.

2. **Auditability** — Terraform-defined schedules are version-controlled. You can `git blame` to see when a scan cadence changed and who approved it.

3. **Least Privilege** — Each scheduled task gets its own IAM role with only the permissions it needs (scan Lambda can't modify Jira, BitSight Lambda can't trigger scans).

4. **Compliance Evidence** — CloudWatch logs prove scans ran on schedule. Pair with DynamoDB task tracking for automated compliance reporting.

5. **Cost Control** — ECS services at `desired_count=0` cost nothing. Scale to 1 only during scan windows, auto-scale back to 0 when done.

**Real-world pattern:** A monthly vulnerability scan that previously required you to be at your desk on the 2nd Tuesday now runs autonomously — starts the Groundplex, waits for snap packs, scans with Trivy, uploads results to S3, emails the report, and scales back down. Total human involvement: zero (until triage).

## Try It Now

```
Ask Claude Code:
"Show me my crontab and any scheduled tasks running on this 
machine. Then help me migrate them to EventBridge Scheduler 
with Terraform, keeping the same cadence."
```

Or for a quick win:
```bash
# List everything that'll break if this machine goes offline
crontab -l && launchctl list | grep -v com.apple
```

Then ask Claude Code to generate the equivalent `aws_scheduler_schedule` resources.
