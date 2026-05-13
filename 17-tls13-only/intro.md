## Scenario
The secure-site web server currently accepts **only TLS 1.3**. A compatibility requirement has arrived: older clients must also be able to connect using TLS 1.2.

## Goal
Update the nginx ConfigMap so both TLSv1.2 and TLSv1.3 are allowed, then restart the Deployment.

## What exists when the scenario starts

| Resource | Type | Namespace | Notes |
|---|---|---|---|
| `secure-site` | Deployment | `web-zone` | nginx |
| `site-tls-config` | ConfigMap | `web-zone` | ssl_protocols TLSv1.3 only |
| `site-tls` | Secret | `web-zone` | TLS certificate for secure.demo.local |
| `secure-site-svc` | Service | `web-zone` | ClusterIP, port 443 |

## Requirements

| Field | Value |
|---|---|
| Starting config | `ssl_protocols TLSv1.3` only |
| Target config | `ssl_protocols TLSv1.2 TLSv1.3` |
| Both must work | TLSv1.2 **AND** TLSv1.3 connections accepted |
