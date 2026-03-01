#!/usr/bin/env bash
# GitHub Actions용 Secrets 설정
# 사용법: CLOUDFLARE_ACCOUNT_ID=xxx CLOUDFLARE_API_TOKEN=xxx ./scripts/setup-github-secrets.sh

set -e
[ -f .env ] && set -a && source .env && set +a

ACCOUNT_ID="${CLOUDFLARE_ACCOUNT_ID:?CLOUDFLARE_ACCOUNT_ID 필요}"
API_TOKEN="${CLOUDFLARE_API_TOKEN:?CLOUDFLARE_API_TOKEN 필요}"

echo "GitHub Secrets 설정 중..."
gh secret set CLOUDFLARE_ACCOUNT_ID --body "$ACCOUNT_ID"
gh secret set CLOUDFLARE_API_TOKEN --body "$API_TOKEN"
echo "완료. push 시 자동 배포됩니다."
gh workflow run deploy.yml 2>/dev/null && echo "배포 워크플로우 수동 실행됨." || true
