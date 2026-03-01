# ellijobs.com

Elli 브랜드 랜딩 페이지. 30년 경력 개발자, AI 바이브코딩, ellipost.com 운영, ellijobs 1인 그룹 비전.

## 배포 상태

- **GitHub**: https://github.com/fredchoi/ellijobs
- **Cloudflare Pages**: https://ellijobs.pages.dev ✅ (Elli 브랜드 페이지)
- **도메인**: www.ellijobs.com, ellijobs.com → Pages에 연결하면 Elli 페이지 표시

## 구조

```
ellijobs/
├── index.html
├── 404.html
├── favicon.svg
├── _redirects          # ellijobs.com → www.ellijobs.com 301
├── css/styles.css
├── js/script.js
├── .github/workflows/
│   └── deploy.yml      # push → Cloudflare Pages 자동 배포
├── scripts/
│   ├── add-domains.sh
│   └── setup-dns.sh
└── package.json
```

## 로컬 실행

```bash
python3 -m http.server 8000
# 또는
npx serve .
```

## 배포

### 자동 배포 (GitHub → Cloudflare Pages)

`main` 브랜치에 푸시하면 GitHub Actions가 자동으로 Cloudflare Pages에 배포합니다.

**필수: GitHub Secrets 설정**

1. [ellijobs → Settings → Secrets and variables → Actions](https://github.com/fredchoi/ellijobs/settings/secrets/actions)
2. **New repository secret** 클릭 후 추가:
   - `CLOUDFLARE_API_TOKEN`: [API Tokens](https://dash.cloudflare.com/?to=/:account/api-tokens) → Create Token → **Edit Cloudflare Workers** 템플릿
   - `CLOUDFLARE_ACCOUNT_ID`: 대시보드 우측 또는 [Find account ID](https://developers.cloudflare.com/fundamentals/account/find-account-and-zone-ids/)

### 수동 배포

```bash
npm run deploy
# 또는
npx wrangler pages deploy . --project-name=ellijobs
```

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

또는 `npm run setup-dns` (환경 변수 설정 후)

- **Account ID**: 대시보드 우측 또는 [Find account ID](https://developers.cloudflare.com/fundamentals/account/find-account-and-zone-ids/)
- **API Token**: [API Tokens](https://dash.cloudflare.com/?to=/:account/api-tokens) → Create Token → **Account** (Zones Read, DNS Edit, Pages Edit)

## 리다이렉트

`_redirects` 파일로 `ellijobs.com` → `www.ellijobs.com` 301 리다이렉트 적용. 두 도메인 모두 동작.
