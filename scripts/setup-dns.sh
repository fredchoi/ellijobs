#!/usr/bin/env bash
# ellijobs.com DNS 설정 스크립트
# Pages 프로젝트에 도메인 연결 + Zone에 CNAME 레코드 추가
# 사용법: CLOUDFLARE_ACCOUNT_ID=xxx CLOUDFLARE_API_TOKEN=xxx ./scripts/setup-dns.sh

set -e

# .env 파일 로드 (존재 시)
[ -f .env ] && set -a && source .env && set +a

ACCOUNT_ID="${CLOUDFLARE_ACCOUNT_ID:?CLOUDFLARE_ACCOUNT_ID 필요}"
API_TOKEN="${CLOUDFLARE_API_TOKEN:?CLOUDFLARE_API_TOKEN 필요}"
ZONE_NAME="ellijobs.com"
PAGES_TARGET="ellijobs.pages.dev"
PROJECT="ellijobs"

API="https://api.cloudflare.com/client/v4"

echo "=== ellijobs.com DNS 설정 ==="

# 1. Zone ID 조회
echo "Zone ID 조회 중..."
ZONE_RESP=$(curl -s -X GET "${API}/zones?name=${ZONE_NAME}" \
  -H "Authorization: Bearer ${API_TOKEN}" \
  -H "Content-Type: application/json")
ZONE_ID=$(echo "$ZONE_RESP" | jq -r '.result[0].id // empty')
if [ -z "$ZONE_ID" ]; then
  echo "오류: ${ZONE_NAME} Zone을 찾을 수 없습니다."
  echo "$ZONE_RESP" | jq .
  exit 1
fi
echo "  Zone ID: $ZONE_ID"

# 2. Pages 프로젝트에 도메인 추가
echo ""
echo "Pages Custom domains 추가 중..."
for DOMAIN in "www.ellijobs.com" "ellijobs.com"; do
  printf "  %s... " "$DOMAIN"
  RES=$(curl -s -w "\n%{http_code}" -X POST "${API}/accounts/${ACCOUNT_ID}/pages/projects/${PROJECT}/domains" \
    -H "Authorization: Bearer ${API_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "{\"name\":\"${DOMAIN}\"}")
  CODE="${RES##*$'\n'}"
  BODY="${RES%$'\n'*}"
  if [ "$CODE" = "200" ] || [ "$CODE" = "201" ]; then
    echo "✓"
  elif echo "$BODY" | jq -e '.errors[0].code == 8000013' >/dev/null 2>&1; then
    echo "이미 존재"
  else
    echo "HTTP $CODE"
    echo "$BODY" | jq -r '.errors[0].message // .' 2>/dev/null || echo "$BODY"
  fi
done

# 3. DNS 레코드 추가 (www, apex)
echo ""
echo "DNS CNAME 레코드 추가 중..."

add_cname() {
  local name="$1"
  local content="$2"
  printf "  %s → %s... " "$name" "$content"
  RES=$(curl -s -w "\n%{http_code}" -X POST "${API}/zones/${ZONE_ID}/dns_records" \
    -H "Authorization: Bearer ${API_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "{
      \"type\": \"CNAME\",
      \"name\": \"${name}\",
      \"content\": \"${content}\",
      \"ttl\": 1,
      \"proxied\": true
    }")
  CODE="${RES##*$'\n'}"
  BODY="${RES%$'\n'*}"
  if [ "$CODE" = "200" ] || [ "$CODE" = "201" ]; then
    echo "✓"
  elif echo "$BODY" | jq -e '.errors[0].code == 81057' >/dev/null 2>&1; then
    echo "이미 존재"
  else
    echo "HTTP $CODE"
    echo "$BODY" | jq -r '.errors[0].message // .' 2>/dev/null || echo "$BODY"
  fi
}

add_cname "www" "${PAGES_TARGET}"
add_cname "@" "${PAGES_TARGET}"

echo ""
echo "=== 완료 ==="
echo "DNS 전파에 1-2분 소요될 수 있습니다."
echo "https://www.ellijobs.com / https://ellijobs.com 확인해 보세요."
