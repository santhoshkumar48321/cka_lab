#!/usr/bin/env bash
set -euo pipefail

if ! kubectl get pvc web-pvc -n frontend >/dev/null 2>&1; then
  echo "PVC 'web-pvc' not found in namespace 'frontend'"
  exit 1
fi

pvc_phase=$(kubectl get pvc web-pvc -n frontend -o jsonpath='{.status.phase}')
if ! test "$pvc_phase" = "Bound"; then
  echo "PVC 'web-pvc' must be Bound, got: $pvc_phase"
  exit 1
fi

pvc_storage=$(kubectl get pvc web-pvc -n frontend -o jsonpath='{.spec.resources.requests.storage}')
if ! test "$pvc_storage" = "250Mi"; then
  echo "PVC 'web-pvc' storage request must be 250Mi, got: $pvc_storage"
  exit 1
fi

pv_phase=$(kubectl get pv web-pv -o jsonpath='{.status.phase}' 2>/dev/null || echo "not-found")
if ! test "$pv_phase" = "Bound"; then
  echo "PV 'web-pv' must be Bound, got: $pv_phase"
  exit 1
fi

vol_mounts=$(kubectl get deployment web-app -n frontend \
  -o jsonpath='{.spec.template.spec.containers[0].volumeMounts}' 2>/dev/null || echo "")
if ! echo "$vol_mounts" | grep -q '/usr/share/nginx/html'; then
  echo "Deployment 'web-app' must mount a volume at /usr/share/nginx/html"
  exit 1
fi

volumes=$(kubectl get deployment web-app -n frontend \
  -o jsonpath='{.spec.template.spec.volumes}' 2>/dev/null || echo "")
if ! echo "$volumes" | grep -q 'web-pvc'; then
  echo "Deployment 'web-app' volume must reference PVC 'web-pvc'"
  exit 1
fi

echo "PASS"
exit 0
