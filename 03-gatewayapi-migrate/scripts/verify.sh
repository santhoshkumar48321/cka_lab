#!/usr/bin/env bash
set -euo pipefail

if ! kubectl get gateway secure-gateway -n default >/dev/null 2>&1; then
  echo "Gateway 'secure-gateway' not found in default namespace"
  exit 1
fi

if ! kubectl get httproute secure-route -n default >/dev/null 2>&1; then
  echo "HTTPRoute 'secure-route' not found in default namespace"
  exit 1
fi

gw_class=$(kubectl get gateway secure-gateway -n default -o jsonpath='{.spec.gatewayClassName}')
if ! test "$gw_class" = "nginx-gateway"; then
  echo "Gateway must use gatewayClassName 'nginx-gateway', got: $gw_class"
  exit 1
fi

# Check HTTPS listener on port 443
gw_port=$(kubectl get gateway secure-gateway -n default -o jsonpath='{.spec.listeners[0].port}')
if ! test "$gw_port" = "443"; then
  echo "Gateway must have listener on port 443, got: $gw_port"
  exit 1
fi

# Check TLS certificateRef
if ! kubectl get gateway secure-gateway -n default -o yaml | grep -q 'api-tls'; then
  echo "Gateway must reference TLS secret 'api-tls'"
  exit 1
fi

hostname=$(kubectl get httproute secure-route -n default -o jsonpath='{.spec.hostnames[0]}')
if ! test "$hostname" = "api.zenhost.local"; then
  echo "HTTPRoute hostname must be 'api.zenhost.local', got: $hostname"
  exit 1
fi

if ! kubectl get httproute secure-route -n default -o yaml | grep -q 'api-backend-svc'; then
  echo "HTTPRoute 'secure-route' does not reference service 'api-backend-svc'"
  exit 1
fi

if ! kubectl get httproute secure-route -n default -o yaml | grep -qE 'name: secure-gateway'; then
  echo "HTTPRoute must reference Gateway 'secure-gateway' in parentRefs"
  exit 1
fi

echo "PASS"
exit 0
