#!/usr/bin/env bash
set -euo pipefail

if ! kubectl --request-timeout=15s get deployment ui-app -n dev-lab >/dev/null 2>&1; then
  echo "Deployment 'ui-app' not found in namespace 'dev-lab'"
  exit 1
fi

if ! kubectl --request-timeout=15s get service ui-service -n dev-lab >/dev/null 2>&1; then
  echo "Service 'ui-service' not found in namespace 'dev-lab'"
  exit 1
fi

svc_type="$(kubectl --request-timeout=15s get service ui-service -n dev-lab -o jsonpath='{.spec.type}')"
if ! test "$svc_type" = "NodePort"; then
  echo "Service 'ui-service' must be type NodePort, got: $svc_type"
  exit 1
fi

port="$(kubectl --request-timeout=15s get service ui-service -n dev-lab -o jsonpath='{.spec.ports[0].port}')"
if ! test "$port" = "80"; then
  echo "Service must expose port 80, got: $port"
  exit 1
fi

node_port="$(kubectl --request-timeout=15s get service ui-service -n dev-lab -o jsonpath='{.spec.ports[0].nodePort}')"
if [ "$node_port" -lt 30000 ] || [ "$node_port" -gt 32767 ]; then
  echo "NodePort must be in range 30000-32767, got: $node_port"
  exit 1
fi

cport="$(kubectl --request-timeout=15s get deployment ui-app -n dev-lab -o jsonpath='{.spec.template.spec.containers[0].ports[0].containerPort}')"
if ! test "$cport" = "80"; then
  echo "Container port must be 80, got: $cport"
  exit 1
fi

echo "PASS"
exit 0
