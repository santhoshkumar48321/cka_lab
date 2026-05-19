## Scenario
In namespace `data-tier`, two Deployments are running: `api-gateway` and `database`. Security policy requires that only `api-gateway` pods can access `database` on PostgreSQL port 5432.

## Goal
Create NetworkPolicy `allow-db-from-gateway` to allow ingress to `database` only from `api-gateway` on TCP 5432, and add an **egress** rule so only database traffic on 5432 is allowed.

## What exists when the scenario starts

| Resource | Type | Namespace | Notes |
|---|---|---|---|
| `api-gateway` | Deployment | `data-tier` | pods labeled `app=api-gateway` |
| `database` | Deployment | `data-tier` | pods labeled `app=database`, listening on 5432 |

## Requirements

| Field | Value |
|---|---|
| Namespace | `data-tier` |
| NetworkPolicy name | `allow-db-from-gateway` |
| Target pods | `app=database` |
| Allow ingress from | `app=api-gateway` |
| Allow egress to | `app=database` |
| Port | `TCP 5432` |
