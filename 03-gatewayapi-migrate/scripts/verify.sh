#!/usr/bin/env bash
set -euo pipefail

if ! kubectl get gateway api-gateway -n default >/dev/null 2>&1; then
  echo "Gateway 'api-gateway' not found in default namespace"
  exit 1
fi

if ! kubectl get httproute api-route -n default >/dev/null 2>&1; then
  echo "HTTPRoute 'api-route' not found in default namespace"
  exit 1
fi

gw_class=$(kubectl get gateway api-gateway -n default -o jsonpath='{.spec.gatewayClassName}')
if ! test "$gw_class" = "nginx-gateway"; then
  echo "Gateway must use gatewayClassName 'nginx-gateway', got: $gw_class"
  exit 1
fi

hostname=$(kubectl get httproute api-route -n default -o jsonpath='{.spec.hostnames[0]}')
if ! test "$hostname" = "api.demo.k8s.local"; then
  echo "HTTPRoute hostname must be 'api.demo.k8s.local', got: $hostname"
  exit 1
fi

if ! kubectl get httproute api-route -n default -o yaml | grep -q 'web-svc'; then
  echo "HTTPRoute 'api-route' does not reference service 'web-svc'"
  exit 1
fi

if ! kubectl get httproute api-route -n default -o yaml | grep -qE 'name: api-gateway'; then
  echo "HTTPRoute must reference Gateway 'api-gateway' in parentRefs"
  exit 1
fi

echo "PASS"
exit 0
