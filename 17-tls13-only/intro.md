## Scenario
The secure-site web server currently allows both TLSv1.2 and TLSv1.3. Security policy now requires disabling TLSv1.2 and keeping only TLSv1.3.

## Goal
Update the nginx ConfigMap so only TLSv1.3 is allowed, then restart the Deployment.

## What exists when the scenario starts

| Resource | Type | Namespace | Notes |
|---|---|---|---|
| `secure-site` | Deployment | `web-zone` | nginx |
| `site-tls-config` | ConfigMap | `web-zone` | ssl_protocols TLSv1.2 TLSv1.3 |
| `site-tls` | Secret | `web-zone` | TLS certificate for secure.demo.local |
| `secure-site-svc` | Service | `web-zone` | ClusterIP, port 443 |

## Requirements

| Field | Value |
|---|---|
| Starting config | `ssl_protocols TLSv1.2 TLSv1.3` (both) — must restrict to TLSv1.3 only |
| Target config | `ssl_protocols TLSv1.3` |
