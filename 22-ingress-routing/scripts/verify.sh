#!/usr/bin/env bash
set -euo pipefail

if ! kubectl --request-timeout=15s get ingress whisper -n sound-zone >/dev/null 2>&1; then
  echo "Ingress 'whisper' not found in namespace 'sound-zone'"
  exit 1
fi

ing_yaml="$(kubectl --request-timeout=15s get ingress whisper -n sound-zone -o yaml)"

if ! echo "$ing_yaml" | grep -q 'mydemo.local'; then
  echo "Ingress 'whisper' host must be 'mydemo.local'"
  exit 1
fi

if ! echo "$ing_yaml" | grep -q 'path: /whisper'; then
  echo "Ingress 'whisper' must route path '/whisper'"
  exit 1
fi

if ! echo "$ing_yaml" | grep -q 'name: soundserver-svc'; then
  echo "Ingress 'whisper' must route to service 'soundserver-svc'"
  exit 1
fi

if ! echo "$ing_yaml" | grep -q 'number: 9090'; then
  echo "Ingress 'whisper' must route to service port 9090"
  exit 1
fi

echo "PASS"
exit 0
