#!/usr/bin/env bash
set -euo pipefail

if ! kubectl get deployment webapp -n default >/dev/null 2>&1; then
  echo "Deployment webapp not found in default namespace"
  exit 1
fi

# Count containers – strip empty lines to avoid off-by-one from jsonpath trailing newline
container_count=$(kubectl get deployment webapp -n default \
  -o jsonpath='{range .spec.template.spec.containers[*]}{.name}{"\n"}{end}' \
  | grep -c .)
if [ "$container_count" -ne 2 ]; then
  echo "Deployment webapp must have exactly 2 containers, found: $container_count"
  exit 1
fi

# Check sidecar name and image
if ! kubectl get deployment webapp -n default -o yaml \
     | grep -E 'name: log-reader' >/dev/null 2>&1; then
  echo "Sidecar container 'log-reader' not found"
  exit 1
fi
if ! kubectl get deployment webapp -n default \
     -o jsonpath='{range .spec.template.spec.containers[*]}{.name}:{.image}{"\n"}{end}' \
     | grep -q '^log-reader:.*busybox:1\.36'; then
  echo "Sidecar 'log-reader' must use image busybox:1.36"
  exit 1
fi

# Check both containers mount /var/log
missing=$(kubectl get deployment webapp -n default \
  -o jsonpath='{range .spec.template.spec.containers[*]}{.name}:{range .volumeMounts[*]}{.mountPath}{" "}{end}{"\n"}{end}' \
  | grep -v '/var/log' | grep -c . || true)
if [ "$missing" -ne 0 ]; then
  echo "Both containers must mount a shared volume at /var/log"
  exit 1
fi

echo "PASS"
exit 0
