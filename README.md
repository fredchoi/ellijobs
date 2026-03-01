# ellijobs.com

Elli 브랜드 랜딩 페이지. 오랜경험과 노하우를 가진 개발자, AI 바이브코딩, ellipost.com 운영, ellijobs 1인 그룹 비전.

## 구조

```
ellijobs/
├── index.html
├── 404.html
├── favicon.svg
├── _redirects
├── css/styles.css
├── js/script.js
├── .github/workflows/deploy.yml   # push → 자동 배포
└── scripts/
    ├── setup-github-secrets.sh    # Secrets 설정
    ├── setup-dns.sh
    └── add-domains.sh
```

## 로컬 실행

```bash
python3 -m http.server 8000
```

## 배포

### 방법 1: GitHub Actions (권장)

`main` 브랜치 push 시 자동 배포. **GitHub Secrets** 필요:

```bash
# 한 번만 실행 (gh CLI + .env 또는 환경변수)
CLOUDFLARE_ACCOUNT_ID=xxx CLOUDFLARE_API_TOKEN=xxx ./scripts/setup-github-secrets.sh
```

또는 [Settings → Secrets → Actions](https://github.com/fredchoi/ellijobs/settings/secrets/actions)에서 수동 추가:
- `CLOUDFLARE_ACCOUNT_ID`
- `CLOUDFLARE_API_TOKEN`

### 방법 2: Cloudflare Git 연동

1. [Workers & Pages](https://dash.cloudflare.com/?to=/:account/pages) → **Create** → **Connect to Git**
2. ellijobs 저장소 선택, Build command 비우기, Output directory `/`

## 도메인 연결

ellijobs.com이 Cloudflare에 등록되어 있으면:

### 방법 1: 대시보드 (권장)

1. [ellijobs Custom domains](https://dash.cloudflare.com/?to=/:account/pages/view/ellijobs/custom-domains) 접속
2. **Set up a custom domain** 클릭
3. **www.ellijobs.com** 입력 후 추가
4. **ellijobs.com** 입력 후 추가
5. Cloudflare가 DNS 레코드 자동 생성 (도메인이 이미 Cloudflare에 있으면 즉시 적용)

> ⚠️ www.ellijobs.com이 다른 프로젝트에 연결되어 있다면, 해당 프로젝트에서 먼저 제거한 뒤 ellijobs에 추가하세요.

### 방법 2: API 스크립트 (DNS + Pages 도메인 일괄 설정)

```bash
CLOUDFLARE_ACCOUNT_ID=your_account_id \
CLOUDFLARE_API_TOKEN=your_api_token \
./scripts/setup-dns.sh
```

(환경 변수 설정 후 `./scripts/setup-dns.sh` 실행)

- **Account ID**: 대시보드 우측 또는 [Find account ID](https://developers.cloudflare.com/fundamentals/account/find-account-and-zone-ids/)
- **API Token**: [API Tokens](https://dash.cloudflare.com/?to=/:account/api-tokens) → Create Token → **Account** (Zones Read, DNS Edit, Pages Edit)

## 리다이렉트

`_redirects` 파일로 `ellijobs.com` → `www.ellijobs.com` 301 리다이렉트 적용. 두 도메인 모두 동작.
