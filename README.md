[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/onetime-secret?utm_medium=integration&utm_source=button&utm_campaign=onetimesecret)

# Onetime Secret on Railway

One-click [Onetime Secret](https://github.com/onetimesecret/onetimesecret) for [Railway](https://railway.com): share passwords and other sensitive text through links that work only once.

## What it deploys

| Service | Built from | Version | Storage |
|---|---|---|---|
| **Onetime Secret** (public) | [`app/`](app/Dockerfile) | `onetimesecret/onetimesecret:v0.26.19@sha256:eb630051046042195a1dee73367f4f02a33ab3275bdc4d77a5d2c3dba88d3f0e` | none (all state is in Valkey) |
| **Valkey** (private) | [`valkey/`](valkey/Dockerfile) | `valkey/valkey:8.1.11-alpine@sha256:2602ace2be6569bc2bbb06f873776516ab9089821525be34f4305c67eb9db02a` | volume at `/data`, append-only file plus snapshots |

Both images are the official ones, pinned by version and digest. Both services build from this repo, so Railway tells deployers when a new version is merged to `main`.

- The app listens on `PORT` (3000) behind Railway's HTTPS domain, with a health check on `/health`.
- Valkey is only reachable over Railway's private network and always needs a password.
- Public sign-up is off. Anyone can create and open secrets; accounts exist only for the admin and users you add.

## Variables

| Service | Variable | Default | Notes |
|---|---|---|---|
| Onetime Secret | `ADMIN_EMAIL` | empty (optional) | E-mail of an admin ("colonel") account to create on start. Set it at deploy time, or later and redeploy |
| Onetime Secret | `ADMIN_PASSWORD` | `${{secret(24,…)}}` | Generated admin password; read it in the service's Variables tab |
| Onetime Secret | `SECRET` | `${{secret(64,"abcdef0123456789")}}` | Root key that encrypts every stored secret. Back it up, never change it |
| Onetime Secret | `HOST` | `${{RAILWAY_PUBLIC_DOMAIN}}` | Host name used in share links. Set it to your custom domain if you add one |
| Onetime Secret | `REDIS_URL` | `redis://default:${{Valkey.VALKEY_PASSWORD}}@${{Valkey.RAILWAY_PRIVATE_DOMAIN}}:6379/0` | Private connection to Valkey |
| Onetime Secret | `PORT` | `3000` | Port Puma listens on |
| Valkey | `VALKEY_PASSWORD` | `${{secret(32,…)}}` | Generated Valkey password |

Fixed settings live in [`app/Dockerfile`](app/Dockerfile) (`SSL=true`, simple auth mode, sign-up off, Railway's proxy range trusted for client IPs and the health check). Override any of them with a service variable, for example `AUTH_SIGNUP=true` to open sign-up, or the `SMTP_*` and `FROM_EMAIL` variables from upstream's [`.env.example`](https://github.com/onetimesecret/onetimesecret/blob/v0.26.19/.env.example) to send e-mail.

## After deploying

1. Open the public URL and share a secret: no login needed.
2. If you set `ADMIN_EMAIL`, sign in at `/signin` with it and the `ADMIN_PASSWORD` from the Onetime Secret service's Variables tab. Admin tools are at `/colonel`.
3. Add more users from the service shell: `bin/ots customers create someone@example.com` prints a generated password.

## Updates

Version bumps land on `main` as a pull request that changes the pinned tag and digest and adds a [CHANGELOG](CHANGELOG.md) entry, with breaking changes listed first. Railway then shows an update notice in your project, and you choose when to apply it. Your secrets stay in the Valkey volume across updates. Read the changelog before applying: Onetime Secret is below 1.0, and upstream says minor releases can carry breaking changes.

## Licence

This wrapper is MIT. Onetime Secret is [MIT](https://github.com/onetimesecret/onetimesecret/blob/main/LICENSE.txt); Valkey is BSD-3-Clause.
