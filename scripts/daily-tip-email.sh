#!/bin/bash
# Daily Claude Tip Email Script
# Sends today's tip (or the latest available) to mstrauss@snaplogic.com via AWS SES

TIPS_DIR="/Users/mmstrauss/dev/claude-tips-and-tricks/_tips"
TODAY=$(date +%Y-%m-%d)

# Find today's tip or the most recent one
TIP_FILE=$(ls "$TIPS_DIR"/${TODAY}*.md 2>/dev/null | head -1)
if [ -z "$TIP_FILE" ]; then
    TIP_FILE=$(ls "$TIPS_DIR"/*.md | sort -r | head -1)
fi

if [ -z "$TIP_FILE" ]; then
    echo "No tips found"
    exit 1
fi

# Extract title from front matter
TITLE=$(grep "^title:" "$TIP_FILE" | sed 's/title: *"\(.*\)"/\1/')
CATEGORY=$(grep "^category:" "$TIP_FILE" | sed 's/category: *//')

# Extract body (everything after second ---)
BODY=$(sed -n '/^---$/,/^---$/!p' "$TIP_FILE" | tail -n +2)

# Send via AWS SES
aws ses send-email \
    --region us-west-2 \
    --from "mstrauss@snaplogic.com" \
    --destination "ToAddresses=mstrauss@snaplogic.com" \
    --message "Subject={Data=\"Claude Tip of the Day: ${TITLE}\",Charset=utf-8},Body={Text={Data=\"${BODY}\n\n---\nCategory: ${CATEGORY}\nArchive: https://strauss-mm.github.io/claude-tips-and-tricks\n\nHappy learning! - Your Claude Code Assistant\",Charset=utf-8}}"

echo "Sent tip: $TITLE"
