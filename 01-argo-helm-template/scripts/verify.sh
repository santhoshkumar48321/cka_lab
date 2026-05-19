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

if ! grep -q 'argocd-no-crds' /home/candidate/argo-cd-crds-disabled.yaml; then
  echo "argo-cd-crds-disabled.yaml must reference namespace argocd-no-crds"
  exit 1
fi

# ── Task 5: namespace + deployment applied to cluster ────────────────────────
if ! kubectl --request-timeout=15s get namespace argocd-no-crds >/dev/null 2>&1; then
  echo "Namespace argocd-no-crds must exist — did you run: kubectl --request-timeout=15s create namespace argocd-no-crds?"
  exit 1
fi

deploy_count=$(kubectl --request-timeout=15s -n argocd-no-crds get deploy --no-headers 2>/dev/null | wc -l)
if [ "$deploy_count" -lt 1 ]; then
  echo "No Deployments found in argocd-no-crds — did you apply argo-cd-crds-disabled.yaml?"
  exit 1
fi

echo "PASS"
exit 0
