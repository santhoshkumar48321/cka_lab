#!/usr/bin/env bash
set -euo pipefail

if ! kubectl get clusterrole deployment-manager >/dev/null 2>&1; then
  echo "ClusterRole 'deployment-manager' not found"
  exit 1
fi

cr_yaml="$(kubectl get clusterrole deployment-manager -o yaml)"
if ! echo "$cr_yaml" | grep -q 'deployments'; then
  echo "ClusterRole 'deployment-manager' must include 'deployments' resource"
  exit 1
fi
if ! echo "$cr_yaml" | grep -q 'create'; then
  echo "ClusterRole 'deployment-manager' must include 'create' verb"
  exit 1
fi

if ! kubectl get rolebinding deploy-bot-staging -n staging >/dev/null 2>&1; then
  echo "RoleBinding 'deploy-bot-staging' not found in namespace 'staging'"
  exit 1
fi

rb_yaml="$(kubectl get rolebinding deploy-bot-staging -n staging -o yaml)"
if ! echo "$rb_yaml" | grep -q 'deployment-manager'; then
  echo "RoleBinding must reference ClusterRole 'deployment-manager'"
  exit 1
fi
if ! echo "$rb_yaml" | grep -q 'deploy-bot'; then
  echo "RoleBinding must reference ServiceAccount 'deploy-bot'"
  exit 1
fi
if ! echo "$rb_yaml" | grep -q 'ci-cd'; then
  echo "RoleBinding subject must be in namespace 'ci-cd'"
  exit 1
fi

result=$(kubectl auth can-i create deployments \
  --as=system:serviceaccount:ci-cd:deploy-bot -n staging 2>/dev/null || echo "no")
if ! test "$result" = "yes"; then
  echo "ServiceAccount deploy-bot cannot create deployments in staging"
  exit 1
fi

result=$(kubectl auth can-i create deployments \
  --as=system:serviceaccount:ci-cd:deploy-bot -n production 2>/dev/null || echo "no")
if test "$result" = "yes"; then
  echo "ServiceAccount deploy-bot must NOT have access to production namespace"
  exit 1
fi

echo "PASS"
exit 0
