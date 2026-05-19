#!/usr/bin/env bash
set -euo pipefail

if ! kubectl --request-timeout=15s get networkpolicy -n project-x >/dev/null 2>&1; then
  echo "No NetworkPolicy found in namespace 'project-x'"
  exit 1
fi

np_count=$(kubectl --request-timeout=15s get networkpolicy -n project-x --no-headers 2>/dev/null | grep -c . || true)
if [ "$np_count" -eq 0 ]; then
  echo "No NetworkPolicy found in namespace 'project-x'"
  exit 1
fi

np_yaml="$(kubectl --request-timeout=15s get networkpolicy -n project-x -o yaml)"

if ! echo "$np_yaml" | grep -q -- 'Ingress'; then
  echo "NetworkPolicy must define Ingress policyType"
  exit 1
fi

if ! echo "$np_yaml" | grep -q 'app: backend\|app=backend'; then
  echo "NetworkPolicy must select pods with label app=backend"
  exit 1
fi

if ! echo "$np_yaml" | grep -q 'app: frontend\|app=frontend'; then
  echo "NetworkPolicy must allow ingress from pods with label app=frontend"
  exit 1
fi

if ! echo "$np_yaml" | grep -q '8080'; then
  echo "NetworkPolicy must specify port 8080"
  exit 1
fi

echo "PASS"
exit 0
