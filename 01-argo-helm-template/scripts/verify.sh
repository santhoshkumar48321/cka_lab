#!/usr/bin/env bash
set -euo pipefail

# ── Task 3: crds-enabled file ────────────────────────────────────────────────
if ! test -s /home/candidate/argo-cd-crds-enabled.yaml; then
  echo "Missing or empty file: /home/candidate/argo-cd-crds-enabled.yaml"
  exit 1
fi

if ! grep -q 'kind: CustomResourceDefinition' /home/candidate/argo-cd-crds-enabled.yaml; then
  echo "argo-cd-crds-enabled.yaml must contain kind: CustomResourceDefinition"
  exit 1
fi

if ! grep -q 'argocd' /home/candidate/argo-cd-crds-enabled.yaml; then
  echo "argo-cd-crds-enabled.yaml must reference namespace argocd"
  exit 1
fi

# ── Task 4: crds-disabled file ───────────────────────────────────────────────
if ! test -s /home/candidate/argo-cd-crds-disabled.yaml; then
  echo "Missing or empty file: /home/candidate/argo-cd-crds-disabled.yaml"
  exit 1
fi

if grep -q 'kind: CustomResourceDefinition' /home/candidate/argo-cd-crds-disabled.yaml; then
  echo "argo-cd-crds-disabled.yaml must NOT contain kind: CustomResourceDefinition"
  exit 1
fi

if ! grep -q 'argocd' /home/candidate/argo-cd-crds-disabled.yaml; then
  echo "argo-cd-crds-disabled.yaml must reference namespace argocd"
  exit 1
fi

if ! kubectl --request-timeout=15s get namespace argocd >/dev/null 2>&1; then
  echo "Namespace argocd must exist"
  exit 1
fi

pod_count=$(kubectl --request-timeout=15s get pods -n argocd --no-headers 2>/dev/null | grep -c Running || echo 0)
if [ "$pod_count" -lt 1 ]; then
  echo "FAIL: No running pods in argocd namespace — apply the manifest first"
  exit 1
fi

echo "PASS"
exit 0
