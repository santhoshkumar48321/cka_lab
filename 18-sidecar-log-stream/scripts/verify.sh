#!/usr/bin/env bash
set -euo pipefail

if ! kubectl --request-timeout=15s get pod atlas-app -n default >/dev/null 2>&1; then
  echo "Pod 'atlas-app' not found in default namespace"
  exit 1
fi

# Count containers – strip blank lines
container_count=$(kubectl --request-timeout=15s get pod atlas-app -n default \
  -o jsonpath='{range .spec.containers[*]}{.name}{"\n"}{end}' \
  | grep -c .)
if [ "$container_count" -ne 2 ]; then
  echo "Pod 'atlas-app' must have exactly 2 containers, found: $container_count"
  exit 1
fi

if ! kubectl --request-timeout=15s get pod atlas-app -n default \
     -o jsonpath='{range .spec.containers[*]}{.name}{"\n"}{end}' \
     | grep -q 'log-sidecar'; then
  echo "Pod 'atlas-app' must have sidecar container named 'log-sidecar'"
  exit 1
fi

# Check image
sidecar_image=$(kubectl --request-timeout=15s get pod atlas-app -n default \
  -o jsonpath='{range .spec.containers[?(@.name=="log-sidecar")]}{.image}{end}')
if ! echo "$sidecar_image" | grep -q 'busybox'; then
  echo "Sidecar 'log-sidecar' must use busybox image, got: $sidecar_image"
  exit 1
fi

# Check command includes tail and the log path
sidecar_args=$(kubectl --request-timeout=15s get pod atlas-app -n default \
  -o jsonpath='{range .spec.containers[?(@.name=="log-sidecar")]}{.command}{.args}{end}')
if ! echo "$sidecar_args" | grep -q 'tail'; then
  echo "Sidecar container 'log-sidecar' must run a tail command"
  exit 1
fi
if ! echo "$sidecar_args" | grep -q 'atlas-app.log'; then
  echo "Sidecar must tail '/var/log/atlas-app.log'"
  exit 1
fi

# Verify shared volume is mounted in sidecar
if ! kubectl --request-timeout=15s get pod atlas-app -n default -o yaml \
     | grep -A5 'name: log-sidecar' | grep -q 'mountPath'; then
  echo "Sidecar 'log-sidecar' must have a volumeMount"
  exit 1
fi

echo "PASS"
exit 0
