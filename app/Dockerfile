# Onetime Secret, official image pinned by version and digest.
# Bump both the tag and the digest together, and add a CHANGELOG.md entry.
FROM onetimesecret/onetimesecret:v0.26.19@sha256:eb630051046042195a1dee73367f4f02a33ab3275bdc4d77a5d2c3dba88d3f0e

# Defaults for Railway. Any of these can be overridden with a service variable.
# - Railway's edge terminates TLS, so links use https and cookies are Secure.
# - Simple auth mode keeps every record (secrets, accounts, sessions) in Valkey.
# - Public sign-up is off: create the admin with `bin/ots customers create`.
# - Railway's edge connects from 100.64.0.0/10 and forwards the client IP in
#   X-Forwarded-For, so per-IP rate limits see real visitors.
# - Railway's health checker also connects from 100.64.0.0/10; upstream only
#   lets private addresses read /health, so that range is allowed too.
ENV RACK_ENV=production \
    SSL=true \
    AUTHENTICATION_MODE=simple \
    AUTH_SIGNUP=false \
    TRUSTED_PROXY_ENABLED=true \
    TRUSTED_PROXY_CIDRS=100.64.0.0/10 \
    HEALTH_TRUSTED_CIDR=100.64.0.0/10 \
    PUMA_WORKERS=2

COPY --chown=appuser:appuser --chmod=755 start.sh /app/bin/railway-start.sh

EXPOSE 3000
CMD ["bin/railway-start.sh"]
