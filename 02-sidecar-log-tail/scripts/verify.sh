#!/usr/bin/env bash
set -euo pipefail

if ! kubectl get deployment myapp -n default >/dev/null 2>&1; then
  echo "Deployment myapp not found in default namespace"
  exit 1
fi

container_count=$(kubectl get deployment myapp -n default \
  -o jsonpath='{range .spec.template.spec.containers[*]}{.name}{"\n"}{end}' \
  | grep -c .)
if [ "$container_count" -ne 2 ]; then
  echo "Deployment myapp must have exactly 2 containers, found: $container_count"
  exit 1
fi

if ! kubectl get deployment myapp -n default -o yaml | grep -q 'name: logshipper'; then
  echo "Sidecar container 'logshipper' not found"
  exit 1
fi

if ! kubectl get deployment myapp -n default \
     -o jsonpath='{range .spec.template.spec.containers[*]}{.name}:{.image}{"\n"}{end}' \
     | grep -q '^logshipper:.*alpine:latest'; then
  echo "Sidecar 'logshipper' must use image alpine:latest"
  exit 1
fi

# Check myapp container still exists with busybox:1.36
if ! kubectl get deployment myapp -n default \
     -o jsonpath='{range .spec.template.spec.containers[*]}{.name}:{.image}{"\n"}{end}' \
     | grep -q '^myapp:.*busybox:1\.36'; then
  echo "Original 'myapp' container must still exist with image busybox:1.36"
  exit 1
fi

# Check logshipper command includes tail and /var/log/logs.txt
logshipper_spec=$(kubectl get deployment myapp -n default -o yaml \
  | grep -A5 'name: logshipper')
if ! echo "$logshipper_spec" | grep -qE 'tail|logs\.txt'; then
  echo "logshipper command must include 'tail' and '/var/log/logs.txt'"
  exit 1
fi

# Check both containers mount /var/log
missing=$(kubectl get deployment myapp -n default \
  -o jsonpath='{range .spec.template.spec.containers[*]}{.name}:{range .volumeMounts[*]}{.mountPath}{" "}{end}{"\n"}{end}' \
  | grep -v '/var/log' | grep -c . || true)
if [ "$missing" -ne 0 ]; then
  echo "Both containers must mount the shared volume at /var/log"
  exit 1
fi

echo "PASS"
exit 0
