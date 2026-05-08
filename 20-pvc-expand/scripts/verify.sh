#!/usr/bin/env bash
set -euo pipefail

if ! kubectl get pvc site-content -n default >/dev/null 2>&1; then
  echo "PVC 'site-content' not found"
  exit 1
fi

phase=$(kubectl get pvc site-content -n default -o jsonpath='{.status.phase}')
if ! test "$phase" = "Bound"; then
  echo "PVC 'site-content' is not Bound (status: $phase)"
  exit 1
fi

req=$(kubectl get pvc site-content -n default -o jsonpath='{.spec.resources.requests.storage}')
# Accept 80Mi or greater (in Mi or Gi)
if ! echo "$req" | awk '
/Gi$/ {exit 0}
/Mi$/ {v=$0; sub(/Mi$/,"",v); if (v+0>=80) exit 0; else exit 1}
{exit 1}
'; then
  echo "PVC 'site-content' must be expanded to at least 80Mi, current spec: $req"
  exit 1
fi

if ! kubectl get pod nginx-site -n default >/dev/null 2>&1; then
  echo "Pod 'nginx-site' not found"
  exit 1
fi

# Check PVC is mounted in the pod
if ! kubectl get pod nginx-site -n default -o yaml | grep -q 'site-content'; then
  echo "Pod 'nginx-site' must mount PVC 'site-content'"
  exit 1
fi

if ! test -s /opt/CKA2026/resize-record.yaml; then
  echo "Missing or empty file: /opt/CKA2026/resize-record.yaml"
  exit 1
fi

echo "PASS"
exit 0
