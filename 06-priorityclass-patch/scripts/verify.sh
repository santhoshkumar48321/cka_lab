#!/usr/bin/env bash
set -euo pipefail

if ! kubectl --request-timeout=15s get priorityclass critical-priority >/dev/null 2>&1; then
  echo "PriorityClass 'critical-priority' not found"
  exit 1
fi

# Highest existing user-defined PriorityClass is high-priority=1000; expected value = 999999
pc_value=$(kubectl --request-timeout=15s get priorityclass critical-priority -o jsonpath='{.value}')
if ! test -n "$pc_value"; then
  echo "PriorityClass 'critical-priority' has no value set"
  exit 1
fi
if ! test "$pc_value" -eq 999999; then
  echo "FAIL: value must be 999999 (expr 1000000 - 1), got: $pc_value"
  exit 1
fi

if ! kubectl --request-timeout=15s get deployment logger-app -n production >/dev/null 2>&1; then
  echo "Deployment 'logger-app' not found in namespace 'production'"
  exit 1
fi

pcn=$(kubectl --request-timeout=15s get deployment logger-app -n production -o jsonpath='{.spec.template.spec.priorityClassName}')
if ! test "$pcn" = "critical-priority"; then
  echo "Deployment 'logger-app' must use priorityClassName 'critical-priority', got: $pcn"
  exit 1
fi

echo "PASS"
exit 0
