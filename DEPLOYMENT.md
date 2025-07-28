# Deployment Guide

## Automatic Scrobbles Updates with GitHub Actions

This project uses GitHub Actions to automatically fetch your Last.fm scrobbles and rebuild the site every 6 hours.

### Required GitHub Secrets

You need to set up the following secrets in your GitHub repository:

1. **Go to your GitHub repository** → Settings → Secrets and variables → Actions
2. **Add the following repository secrets:**

#### Last.fm API Credentials
- `LASTFM_API_KEY` - Your Last.fm API key
- `LASTFM_API_SECRET` - Your Last.fm API secret  
- `LASTFM_USERNAME` - Your Last.fm username

#### Cloudflare Credentials
- `CLOUDFLARE_API_TOKEN` - Your Cloudflare API token
- `CLOUDFLARE_ACCOUNT_ID` - Your Cloudflare account ID

### How to Get Cloudflare Credentials

1. **API Token:**
   - Go to Cloudflare Dashboard → My Profile → API Tokens
   - Create a new token with "Cloudflare Pages" permissions
   - Include your specific account and project

2. **Account ID:**
   - Go to Cloudflare Dashboard → Right sidebar → Account ID

### Workflow Details

- **Schedule**: Runs every 6 hours automatically
- **Manual Trigger**: You can also run it manually via GitHub Actions tab
- **Process**: 
  1. Fetches your last 20 scrobbles from Last.fm
  2. Builds the Hugo site with updated data
  3. Deploys to Cloudflare Pages

### Local Development

For local development, use the `.env` file:

```bash
cp env.example .env
# Edit .env with your credentials
./scripts/build.sh
```

### Troubleshooting

- Check the GitHub Actions logs if the workflow fails
- Ensure all secrets are properly set
- Verify your Cloudflare project name matches `mcsite` 