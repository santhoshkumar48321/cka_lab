#!/usr/bin/env bash
set -euo pipefail

if ! kubectl get deployment webapp-deployment -n default >/dev/null 2>&1; then
  echo "Deployment 'webapp-deployment' not found"
  exit 1
fi

# Check replicas = 3
replicas="$(kubectl get deployment webapp-deployment -n default -o jsonpath='{.spec.replicas}')"
if ! test "$replicas" -eq 3; then
  echo "Deployment must have 3 replicas, found: $replicas"
  exit 1
fi

cpu_to_millicores() {
  local cpu="$1"
  if test -z "$cpu"; then
    echo ""
    return
  fi
  if echo "$cpu" | grep -q 'm$'; then
    echo "${cpu%m}"
    return
  fi
  awk -v cpu="$cpu" 'BEGIN {printf "%d", cpu * 1000}'
}

mem_to_mib() {
  local mem="$1"
  if test -z "$mem"; then
    echo ""
    return
  fi
  case "$mem" in
    *Ki) awk "BEGIN {printf \"%d\", ${mem%Ki} / 1024}" ;;
    *Mi) echo "${mem%Mi}" ;;
    *Gi) awk "BEGIN {printf \"%d\", ${mem%Gi} * 1024}" ;;
    *Ti) awk "BEGIN {printf \"%d\", ${mem%Ti} * 1024 * 1024}" ;;
    *) echo "$mem" ;;
  esac
}

expected_cpu_req="200m"
expected_mem_req="128Mi"
expected_cpu_lim="400m"
expected_mem_lim="256Mi"

cpu_req="$(kubectl get deployment webapp-deployment -n default -o jsonpath='{.spec.template.spec.containers[0].resources.requests.cpu}')"
mem_req="$(kubectl get deployment webapp-deployment -n default -o jsonpath='{.spec.template.spec.containers[0].resources.requests.memory}')"
cpu_lim="$(kubectl get deployment webapp-deployment -n default -o jsonpath='{.spec.template.spec.containers[0].resources.limits.cpu}')"
mem_lim="$(kubectl get deployment webapp-deployment -n default -o jsonpath='{.spec.template.spec.containers[0].resources.limits.memory}')"

if ! test "$cpu_req" = "$expected_cpu_req"; then
  echo "Main container CPU requests must be $expected_cpu_req, found: $cpu_req"
  exit 1
fi
if ! test "$mem_req" = "$expected_mem_req"; then
  echo "Main container memory requests must be $expected_mem_req, found: $mem_req"
  exit 1
fi
if ! test "$cpu_lim" = "$expected_cpu_lim"; then
  echo "Main container CPU limits must be $expected_cpu_lim, found: $cpu_lim"
  exit 1
fi
if ! test "$mem_lim" = "$expected_mem_lim"; then
  echo "Main container memory limits must be $expected_mem_lim, found: $mem_lim"
  exit 1
fi

init_cpu_req="$(kubectl get deployment webapp-deployment -n default -o jsonpath='{.spec.template.spec.initContainers[0].resources.requests.cpu}')"
init_mem_req="$(kubectl get deployment webapp-deployment -n default -o jsonpath='{.spec.template.spec.initContainers[0].resources.requests.memory}')"
init_cpu_lim="$(kubectl get deployment webapp-deployment -n default -o jsonpath='{.spec.template.spec.initContainers[0].resources.limits.cpu}')"
init_mem_lim="$(kubectl get deployment webapp-deployment -n default -o jsonpath='{.spec.template.spec.initContainers[0].resources.limits.memory}')"

if ! test "$init_cpu_req" = "$expected_cpu_req"; then
  echo "initContainer CPU requests must be $expected_cpu_req, found: $init_cpu_req"
  exit 1
fi
if ! test "$init_mem_req" = "$expected_mem_req"; then
  echo "initContainer memory requests must be $expected_mem_req, found: $init_mem_req"
  exit 1
fi
if ! test "$init_cpu_lim" = "$expected_cpu_lim"; then
  echo "initContainer CPU limits must be $expected_cpu_lim, found: $init_cpu_lim"
  exit 1
fi
if ! test "$init_mem_lim" = "$expected_mem_lim"; then
  echo "initContainer memory limits must be $expected_mem_lim, found: $init_mem_lim"
  exit 1
fi

cpu_req_val="$(cpu_to_millicores "$cpu_req")"
cpu_lim_val="$(cpu_to_millicores "$cpu_lim")"
if ! test "$cpu_lim_val" -ge "$cpu_req_val"; then
  echo "Main container CPU limits ($cpu_lim) must be >= requests ($cpu_req)"
  exit 1
fi

mem_req_val="$(mem_to_mib "$mem_req")"
mem_lim_val="$(mem_to_mib "$mem_lim")"
if ! test "$mem_lim_val" -ge "$mem_req_val"; then
  echo "Main container memory limits ($mem_lim) must be >= requests ($mem_req)"
  exit 1
fi

init_cpu_req_val="$(cpu_to_millicores "$init_cpu_req")"
init_cpu_lim_val="$(cpu_to_millicores "$init_cpu_lim")"
if ! test "$init_cpu_lim_val" -ge "$init_cpu_req_val"; then
  echo "initContainer CPU limits ($init_cpu_lim) must be >= requests ($init_cpu_req)"
  exit 1
fi

init_mem_req_val="$(mem_to_mib "$init_mem_req")"
init_mem_lim_val="$(mem_to_mib "$init_mem_lim")"
if ! test "$init_mem_lim_val" -ge "$init_mem_req_val"; then
  echo "initContainer memory limits ($init_mem_lim) must be >= requests ($init_mem_req)"
  exit 1
fi

echo "PASS"
exit 0
