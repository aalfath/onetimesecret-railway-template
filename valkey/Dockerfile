# Valkey (Redis-compatible), official image pinned by version and digest.
# Onetime Secret keeps every secret, account and session here.
FROM valkey/valkey:8.1.11-alpine@sha256:2602ace2be6569bc2bbb06f873776516ab9089821525be34f4305c67eb9db02a

COPY start.sh /usr/local/bin/railway-start.sh
RUN chmod 755 /usr/local/bin/railway-start.sh

EXPOSE 6379
ENTRYPOINT ["/usr/local/bin/railway-start.sh"]
