#!/usr/bin/env bash
set -euo pipefail

if ! kubectl --request-timeout=15s get pvc db-claim -n db-ns >/dev/null 2>&1; then
  echo "PVC 'db-claim' not found in namespace 'db-ns'"
  exit 1
fi

pvc_phase=$(kubectl --request-timeout=15s get pvc db-claim -n db-ns -o jsonpath='{.status.phase}')
if ! test "$pvc_phase" = "Bound"; then
  echo "PVC 'db-claim' must be Bound, got: $pvc_phase"
  exit 1
fi

pv_phase=$(kubectl --request-timeout=15s get pv db-pv -o jsonpath='{.status.phase}' 2>/dev/null || echo "not-found")
if ! test "$pv_phase" = "Bound"; then
  echo "PV 'db-pv' must be Bound, got: $pv_phase"
  exit 1
fi

vol_mounts=$(kubectl --request-timeout=15s get deployment postgres -n db-ns -o jsonpath='{.spec.template.spec.containers[0].volumeMounts}' 2>/dev/null || echo "")
if ! echo "$vol_mounts" | grep -q '/var/lib/postgresql/data'; then
  echo "Deployment 'postgres' must mount a volume at /var/lib/postgresql/data"
  exit 1
fi

volumes=$(kubectl --request-timeout=15s get deployment postgres -n db-ns -o jsonpath='{.spec.template.spec.volumes}' 2>/dev/null || echo "")
if ! echo "$volumes" | grep -q 'db-claim'; then
  echo "Deployment 'postgres' volume must reference PVC 'db-claim'"
  exit 1
fi

pod_name=$(kubectl --request-timeout=15s get pods -n db-ns -l app=postgres -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || echo "")
if [ -z "$pod_name" ]; then
  echo "Postgres pod not found in namespace 'db-ns'"
  exit 1
fi

if ! kubectl --request-timeout=15s logs "$pod_name" -n db-ns 2>/dev/null | grep -q 'ready to accept connections'; then
  echo "PostgreSQL has not initialized — check PVC mount and POSTGRES_PASSWORD env var"
  exit 1
fi

echo "PASS"
exit 0
