#!/usr/bin/env bash
set -euo pipefail

if ! kubectl --request-timeout=15s get networkpolicy allow-db-from-gateway -n data-tier >/dev/null 2>&1; then
  echo "NetworkPolicy 'allow-db-from-gateway' not found in namespace 'data-tier'"
  exit 1
fi

np_yaml="$(kubectl --request-timeout=15s get networkpolicy allow-db-from-gateway -n data-tier -o yaml)"

if ! echo "$np_yaml" | grep -q 'Ingress'; then
  echo "NetworkPolicy must define Ingress policyType"
  exit 1
fi

if ! echo "$np_yaml" | grep -q 'Egress'; then
  echo "NetworkPolicy must define Egress policyType"
  exit 1
fi

if ! echo "$np_yaml" | grep -qE 'app: database|app=database'; then
  echo "NetworkPolicy must select pods with label app=database"
  exit 1
fi

if ! echo "$np_yaml" | grep -qE 'app: api-gateway|app=api-gateway'; then
  echo "NetworkPolicy must allow ingress from pods with label app=api-gateway"
  exit 1
fi

if ! echo "$np_yaml" | grep -q '5432'; then
  echo "NetworkPolicy must specify port 5432"
  exit 1
fi

if ! echo "$np_yaml" | grep -q 'egress:'; then
  echo "NetworkPolicy must define egress rules"
  exit 1
fi

if ! echo "$np_yaml" | grep -qE 'app: database|app=database'; then
  echo "NetworkPolicy egress must allow traffic to pods with label app=database"
  exit 1
fi

echo "PASS"
exit 0
