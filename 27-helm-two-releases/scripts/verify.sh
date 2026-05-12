#!/usr/bin/env bash
set -euo pipefail

if ! test -s /home/candidate/argo-cd-crds-enabled.yaml; then
  echo "Missing or empty file: /home/candidate/argo-cd-crds-enabled.yaml"
  exit 1
fi

if ! test -s /home/candidate/argo-cd-crds-disabled.yaml; then
  echo "Missing or empty file: /home/candidate/argo-cd-crds-disabled.yaml"
  exit 1
fi

if ! grep -q 'kind: CustomResourceDefinition' /home/candidate/argo-cd-crds-enabled.yaml; then
  echo "argo-cd-crds-enabled.yaml must contain kind: CustomResourceDefinition"
  exit 1
fi

if grep -q 'kind: CustomResourceDefinition' /home/candidate/argo-cd-crds-disabled.yaml; then
  echo "argo-cd-crds-disabled.yaml must NOT contain kind: CustomResourceDefinition"
  exit 1
fi

if ! grep -q 'argocd' /home/candidate/argo-cd-crds-enabled.yaml; then
  echo "argo-cd-crds-enabled.yaml must reference namespace argocd"
  exit 1
fi

if ! grep -q 'argocd-no-crds' /home/candidate/argo-cd-crds-disabled.yaml; then
  echo "argo-cd-crds-disabled.yaml must reference namespace argocd-no-crds"
  exit 1
fi

echo "PASS"
exit 0
