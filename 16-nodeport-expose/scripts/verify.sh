#!/usr/bin/env bash
set -euo pipefail

if ! kubectl --request-timeout=15s get pod web-pod -n nodeport-lab >/dev/null 2>&1; then
  echo "Pod 'web-pod' not found in namespace 'nodeport-lab'"
  exit 1
fi

phase="$(kubectl --request-timeout=15s get pod web-pod -n nodeport-lab -o jsonpath='{.status.phase}')"
if ! test "$phase" = "Running"; then
  echo "Pod 'web-pod' must be Running, got: $phase"
  exit 1
fi

if ! kubectl --request-timeout=15s get svc web-svc -n nodeport-lab >/dev/null 2>&1; then
  echo "Service 'web-svc' not found in namespace 'nodeport-lab'"
  exit 1
fi

svc_type="$(kubectl --request-timeout=15s get svc web-svc -n nodeport-lab -o jsonpath='{.spec.type}')"
if ! test "$svc_type" = "NodePort"; then
  echo "Service 'web-svc' must be type NodePort, got: $svc_type"
  exit 1
fi

selector_app="$(kubectl --request-timeout=15s get svc web-svc -n nodeport-lab -o jsonpath='{.spec.selector.app}')"
if ! test "$selector_app" = "web-pod"; then
  echo "Service selector must be app=web-pod, got: app=$selector_app"
  exit 1
fi

node_port="$(kubectl --request-timeout=15s get svc web-svc -n nodeport-lab -o jsonpath='{.spec.ports[0].nodePort}')"
if [ -z "$node_port" ] || [ "$node_port" -lt 30000 ] || [ "$node_port" -gt 32767 ]; then
  echo "NodePort must be in range 30000-32767, got: $node_port"
  exit 1
fi

echo "PASS"
exit 0
