#!/usr/bin/env bash
set -euo pipefail

if ! kubectl --request-timeout=15s get deployment web-api -n api-ns >/dev/null 2>&1; then
  echo "Deployment 'web-api' not found in namespace 'api-ns'"
  exit 1
fi

if ! kubectl --request-timeout=15s get configmap web-api-config -n api-ns >/dev/null 2>&1; then
  echo "ConfigMap 'web-api-config' not found in namespace 'api-ns'"
  exit 1
fi

if ! kubectl --request-timeout=15s get service web-api-svc -n api-ns >/dev/null 2>&1; then
  echo "Service 'web-api-svc' not found in namespace 'api-ns'"
  exit 1
fi

svc_type="$(kubectl --request-timeout=15s get service web-api-svc -n api-ns -o jsonpath='{.spec.type}')"
if ! test "$svc_type" = "NodePort"; then
  echo "Service 'web-api-svc' must be type NodePort, got: $svc_type"
  exit 1
fi

port="$(kubectl --request-timeout=15s get service web-api-svc -n api-ns -o jsonpath='{.spec.ports[0].port}')"
if ! test "$port" = "8080"; then
  echo "Service must expose port 8080, got: $port"
  exit 1
fi

cport="$(kubectl --request-timeout=15s get deployment web-api -n api-ns -o jsonpath='{.spec.template.spec.containers[0].ports[0].containerPort}')"
if ! test "$cport" = "8080"; then
  echo "Container port must be 8080, got: $cport"
  exit 1
fi

pname="$(kubectl --request-timeout=15s get deployment web-api -n api-ns -o jsonpath='{.spec.template.spec.containers[0].ports[0].name}')"
if ! test "$pname" = "api"; then
  echo "Container port name must be api, got: $pname"
  exit 1
fi

mounts="$(kubectl --request-timeout=15s get deployment web-api -n api-ns -o jsonpath='{.spec.template.spec.containers[0].volumeMounts}' 2>/dev/null || echo "")"
if ! echo "$mounts" | grep -q '/etc/api'; then
  echo "Deployment must mount ConfigMap at /etc/api"
  exit 1
fi

volumes="$(kubectl --request-timeout=15s get deployment web-api -n api-ns -o jsonpath='{.spec.template.spec.volumes}' 2>/dev/null || echo "")"
if ! echo "$volumes" | grep -q 'web-api-config'; then
  echo "Deployment must include a volume from ConfigMap 'web-api-config'"
  exit 1
fi

echo "PASS"
exit 0
