#!/usr/bin/env bash
# ellijobs.com 도메인 연결 스크립트
# 사용법: CLOUDFLARE_ACCOUNT_ID=xxx CLOUDFLARE_API_TOKEN=xxx ./scripts/add-domains.sh

set -e

ACCOUNT_ID="${CLOUDFLARE_ACCOUNT_ID:?CLOUDFLARE_ACCOUNT_ID 필요 (대시보드 우측 또는 /cdn-cgi/trace)}"
API_TOKEN="${CLOUDFLARE_API_TOKEN:?CLOUDFLARE_API_TOKEN 필요 (dash.cloudflare.com → API Tokens)}"
PROJECT="ellijobs"
BASE="https://api.cloudflare.com/client/v4/accounts/${ACCOUNT_ID}/pages/projects/${PROJECT}"

add_domain() {
  local domain="$1"
  printf "Adding %s... " "$domain"
  local res
  res=$(curl -s -w "\n%{http_code}" -X POST "${BASE}/domains" \
    -H "Authorization: Bearer ${API_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "{\"name\":\"${domain}\"}")
  local code="${res##*$'\n'}"
  local body="${res%$'\n'*}"
  if [ "$code" = "200" ] || [ "$code" = "201" ]; then
    echo "✓"
  else
    echo "✗ (HTTP $code)"
    echo "$body" | jq -r '.errors[0].message // .message // .' 2>/dev/null || true
  fi
}

echo "ellijobs Pages 도메인 연결"
add_domain "www.ellijobs.com"
add_domain "ellijobs.com"
echo "완료. DNS 전파에 1-2분 소요될 수 있습니다."
