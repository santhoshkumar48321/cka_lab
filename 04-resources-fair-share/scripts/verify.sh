#!/usr/bin/env bash
set -euo pipefail

if ! kubectl --request-timeout=15s get deployment webapp-deployment -n default >/dev/null 2>&1; then
  echo "Deployment 'webapp-deployment' not found"
  exit 1
fi

# Check replicas = 3
replicas="$(kubectl --request-timeout=15s get deployment webapp-deployment -n default -o jsonpath='{.spec.replicas}')"
if ! test "$replicas" -eq 3; then
  echo "Deployment must have 3 replicas, found: $replicas"
  exit 1
fi

cpu_req="$(kubectl --request-timeout=15s get deployment webapp-deployment -n default -o jsonpath='{.spec.template.spec.containers[0].resources.requests.cpu}')"
mem_req="$(kubectl --request-timeout=15s get deployment webapp-deployment -n default -o jsonpath='{.spec.template.spec.containers[0].resources.requests.memory}')"
cpu_lim="$(kubectl --request-timeout=15s get deployment webapp-deployment -n default -o jsonpath='{.spec.template.spec.containers[0].resources.limits.cpu}')"
mem_lim="$(kubectl --request-timeout=15s get deployment webapp-deployment -n default -o jsonpath='{.spec.template.spec.containers[0].resources.limits.memory}')"

if test -z "$cpu_req"; then
  echo "Main container CPU requests must be set"
  exit 1
fi
if test -z "$mem_req"; then
  echo "Main container memory requests must be set"
  exit 1
fi
if test -z "$cpu_lim"; then
  echo "Main container CPU limits must be set"
  exit 1
fi
if test -z "$mem_lim"; then
  echo "Main container memory limits must be set"
  exit 1
fi

init_cpu_req="$(kubectl --request-timeout=15s get deployment webapp-deployment -n default -o jsonpath='{.spec.template.spec.initContainers[0].resources.requests.cpu}')"
init_mem_req="$(kubectl --request-timeout=15s get deployment webapp-deployment -n default -o jsonpath='{.spec.template.spec.initContainers[0].resources.requests.memory}')"
init_cpu_lim="$(kubectl --request-timeout=15s get deployment webapp-deployment -n default -o jsonpath='{.spec.template.spec.initContainers[0].resources.limits.cpu}')"
init_mem_lim="$(kubectl --request-timeout=15s get deployment webapp-deployment -n default -o jsonpath='{.spec.template.spec.initContainers[0].resources.limits.memory}')"

if test -z "$init_cpu_req" || test -z "$init_mem_req" || test -z "$init_cpu_lim" || test -z "$init_mem_lim"; then
  echo "initContainer resource requests and limits must be set"
  exit 1
fi

if ! test "$init_cpu_req" = "$cpu_req"; then
  echo "initContainer CPU requests must match main container ($cpu_req), found: $init_cpu_req"
  exit 1
fi
if ! test "$init_mem_req" = "$mem_req"; then
  echo "initContainer memory requests must match main container ($mem_req), found: $init_mem_req"
  exit 1
fi
if ! test "$init_cpu_lim" = "$cpu_lim"; then
  echo "initContainer CPU limits must match main container ($cpu_lim), found: $init_cpu_lim"
  exit 1
fi
if ! test "$init_mem_lim" = "$mem_lim"; then
  echo "initContainer memory limits must match main container ($mem_lim), found: $init_mem_lim"
  exit 1
fi

echo "PASS"
exit 0
