#!/usr/bin/env bash
set -euo pipefail

if ! kubectl --request-timeout=15s get configmap secure-site-config -n web-zone >/dev/null 2>&1; then
  echo "ConfigMap 'secure-site-config' not found in namespace 'web-zone'"
  exit 1
fi

cm_yaml="$(kubectl --request-timeout=15s get configmap secure-site-config -n web-zone -o yaml)"

if ! echo "$cm_yaml" | grep 'ssl_protocols' | grep -q 'TLSv1\.2'; then
  echo "nginx config must allow TLSv1.2"
  exit 1
fi

if ! echo "$cm_yaml" | grep 'ssl_protocols' | grep -q 'TLSv1\.3'; then
  echo "nginx config must explicitly allow TLSv1.3"
  exit 1
fi

echo "PASS"
exit 0
