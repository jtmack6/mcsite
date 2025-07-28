#!/usr/bin/env fish

# Quick script to trigger scrobbles update
# Run from anywhere in the project: ./trigger-scrobbles.fish

echo "🎵 Triggering scrobbles update..."

gh workflow run "update-scrobbles-cloudflare-build.yml" --repo jtmack6/mcsite

if test $status -eq 0
    echo "✅ Workflow triggered! Check: https://github.com/jtmack6/mcsite/actions"
else
    echo "❌ Failed to trigger workflow"
end 