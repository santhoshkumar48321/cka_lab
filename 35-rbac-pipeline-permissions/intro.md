## Scenario
A CI/CD pipeline uses ServiceAccount deploy-bot in the ci-cd namespace. It needs permission to create and update Deployments in the staging namespace only. It must not have any permissions in the production namespace.

## Goal
Create a ClusterRole deployment-manager with deployment permissions, then bind it to ServiceAccount deploy-bot scoped only to the staging namespace using a RoleBinding.

## What exists when the scenario starts

| Resource | Type | Namespace | Notes |
|---|---|---|---|
| `deploy-bot` | ServiceAccount | `ci-cd` | CI/CD pipeline service account |
| `staging` | Namespace | — | Target namespace for permissions |
| `production` | Namespace | — | Must NOT have access |

## Requirements

| Field | Value |
|---|---|
| ClusterRole name | `deployment-manager` |
| Allowed resources | `deployments` (apps group) |
| Allowed verbs | `get`, `list`, `create`, `update`, `patch` |
| RoleBinding name | `deploy-bot-staging` |
| RoleBinding namespace | `staging` |
| Subject | ServiceAccount `deploy-bot` in `ci-cd` |

> **Why RoleBinding (not ClusterRoleBinding)?** ClusterRoleBinding would grant permissions cluster-wide. RoleBinding restricts it to the staging namespace while still referencing a ClusterRole.
