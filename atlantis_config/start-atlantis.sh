#!/bin/sh
set -e

. ./atlantis.var

atlantis server \
  --gh-app-id="$GH_APP_ID" \
  --gh-app-key-file="$GH_APP_KEY_FILE" \
  --repo-allowlist="$REPO_ALLOWLIST" \
  --port="$PORT" \
  --atlantis-url="$ATLANTIS_URL" \
  --gh-webhook-secret="$WEBHOOK_SECRET" \
  --write-git-creds
