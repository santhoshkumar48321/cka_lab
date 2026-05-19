#!/usr/bin/env bash
set -euo pipefail

if ! kubectl --request-timeout=15s get configmap site-tls-config -n web-zone >/dev/null 2>&1; then
  echo "ConfigMap 'site-tls-config' not found in namespace 'web-zone'"
  exit 1
fi

cm_yaml="$(kubectl --request-timeout=15s get configmap site-tls-config -n web-zone -o yaml)"
if echo "$cm_yaml" | grep 'ssl_protocols' | grep -q 'TLSv1.2'; then
  echo "nginx config must NOT include TLSv1.2 in ssl_protocols"
  exit 1
fi
if ! echo "$cm_yaml" | grep 'ssl_protocols' | grep -q 'TLSv1.3'; then
  echo "nginx config must include TLSv1.3 in ssl_protocols"
  exit 1
fi

echo "PASS"
exit 0
