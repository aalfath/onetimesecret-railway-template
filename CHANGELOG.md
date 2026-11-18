# Changelog

## 2026-11-18: Onetime Secret v0.26.19

First release of this template.

- Onetime Secret `v0.26.19` (`onetimesecret/onetimesecret@sha256:eb630051046042195a1dee73367f4f02a33ab3275bdc4d77a5d2c3dba88d3f0e`).
- Valkey `8.1.11-alpine` (`valkey/valkey@sha256:2602ace2be6569bc2bbb06f873776516ab9089821525be34f4305c67eb9db02a`) with append-only persistence on a volume at `/data`.
- Optional first-start admin account from `ADMIN_EMAIL` and the generated `ADMIN_PASSWORD`.
- Health check on `/health`, allowed for Railway's checker range (`HEALTH_TRUSTED_CIDR=100.64.0.0/10`).
- Client IPs taken from Railway's proxy (`TRUSTED_PROXY_ENABLED=true`, `TRUSTED_PROXY_CIDRS=100.64.0.0/10`), so per-IP rate limits apply per visitor.
