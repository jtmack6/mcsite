#!/usr/bin/env fish

# Trigger GitHub Actions workflow to update scrobbles
# Usage: ./scripts/trigger-scrobbles.fish

set -l repo "jtmack6/mcsite"
set -l workflow "update-scrobbles-cloudflare-build.yml"

echo "🎵 Triggering scrobbles update workflow..."

# Check if gh CLI is installed
if not command -q gh
    echo "❌ Error: GitHub CLI (gh) is not installed"
    echo "Install it from: https://cli.github.com/"
    exit 1
end

# Check if user is authenticated
if not gh auth status >/dev/null 2>&1
    echo "❌ Error: Not authenticated with GitHub CLI"
    echo "Run: gh auth login"
    exit 1
end

# Trigger the workflow
echo "📡 Triggering workflow: $workflow"
gh workflow run $workflow --repo $repo

if test $status -eq 0
    echo "✅ Workflow triggered successfully!"
    echo "📊 Check progress at: https://github.com/$repo/actions"
    echo "🌐 Your site will be updated at: https://www.mack.sh/scrobbles"
else
    echo "❌ Failed to trigger workflow"
    exit 1
end 