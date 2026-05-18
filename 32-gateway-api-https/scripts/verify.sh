#!/usr/bin/env bash
set -euo pipefail

if ! kubectl get gateway web-gateway -n default >/dev/null 2>&1; then
  echo "Gateway 'web-gateway' not found in default namespace"
  exit 1
fi

if ! kubectl get httproute web-route -n default >/dev/null 2>&1; then
  echo "HTTPRoute 'web-route' not found in default namespace"
  exit 1
fi

gw_class=$(kubectl get gateway web-gateway -n default -o jsonpath='{.spec.gatewayClassName}')
if ! test "$gw_class" = "nginx-class"; then
  echo "Gateway must use gatewayClassName 'nginx-class', got: $gw_class"
  exit 1
fi

if ! kubectl get gateway web-gateway -n default -o yaml | grep -q 'web-tls'; then
  echo "Gateway must reference TLS secret 'web-tls'"
  exit 1
fi

hostname=$(kubectl get httproute web-route -n default -o jsonpath='{.spec.hostnames[0]}')
if ! test "$hostname" = "web.cluster.local"; then
  echo "HTTPRoute hostname must be 'web.cluster.local', got: $hostname"
  exit 1
fi

if ! kubectl get httproute web-route -n default -o yaml | grep -q 'web-backend-svc'; then
  echo "HTTPRoute 'web-route' must reference service 'web-backend-svc'"
  exit 1
fi

echo "PASS"
exit 0
