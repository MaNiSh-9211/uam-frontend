# uam-frontend

**Deployable repo:** React login console + nginx (same-origin proxy to gateway).

Browser talks only to this origin; nginx forwards `/api/*` to the gateway. Refresh tokens live in HttpOnly cookies (ADR-0055).

## Build

TypeScript 7 (Go-native `tsc`) + Vite — source in `src/` only:

```bash
npm install
npm run build
npm run typecheck
```

```bash
docker build -t uam-frontend:latest .
```

## Run (standalone)

```bash
docker run --rm -p 8091:80 uam-frontend:latest
```

For a working auth flow, run the full dev stack so nginx can reach the gateway and UAM backend:

```bash
cd ../dev
docker compose -f docker-compose.yml -f docker-compose.uam.yml up --build
```

Console: http://localhost:8091

## Production

Public LoadBalancer or CDN. Helm: [`../platform/deploy/helm/uam/`](../platform/deploy/helm/uam/)

### Render

Set in the **Render dashboard** (not in git):

| Variable | Example |
|----------|---------|
| `VITE_API_URL` | `/api` |
| `GATEWAY_PROXY_PASS` | `https://YOUR-GATEWAY.onrender.com/api/` |
| `GATEWAY_PROXY_HOST` | `YOUR-GATEWAY.onrender.com` |

`nginx.conf.template` is rendered at container start via `docker-entrypoint.sh`.
Local Compose keeps defaults (`http://gateway:8080/api/`).
