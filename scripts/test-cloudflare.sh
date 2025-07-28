#!/bin/bash

# Test Cloudflare credentials
# Usage: ./scripts/test-cloudflare.sh

echo "Testing Cloudflare credentials..."

# Check if environment variables are set
if [ -z "$CLOUDFLARE_API_TOKEN" ]; then
    echo "❌ CLOUDFLARE_API_TOKEN not set"
    echo "   Set it with: export CLOUDFLARE_API_TOKEN=your_token_here"
    exit 1
fi

if [ -z "$CLOUDFLARE_ACCOUNT_ID" ]; then
    echo "❌ CLOUDFLARE_ACCOUNT_ID not set"
    echo "   Set it with: export CLOUDFLARE_ACCOUNT_ID=your_account_id_here"
    exit 1
fi

echo "✅ Environment variables are set"

# Test API token by listing Pages projects
echo "Testing API token..."
response=$(curl -s -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
    "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/pages/projects")

# Check if the response contains an error
if echo "$response" | grep -q '"success":false'; then
    echo "❌ API token test failed"
    echo "Response: $response"
    exit 1
else
    echo "✅ API token is valid"
    echo "Found Pages projects:"
    echo "$response" | grep -o '"name":"[^"]*"' | sed 's/"name":"//g' | sed 's/"//g'
fi

echo "✅ All Cloudflare credentials are working correctly!" 