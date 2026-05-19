#!/usr/bin/env bash
set -euo pipefail

installed=0

if kubectl --request-timeout=15s get namespace tigera-operator >/dev/null 2>&1; then
  installed=1
fi

if kubectl --request-timeout=15s get namespace calico-system >/dev/null 2>&1; then
  installed=1
fi

if kubectl --request-timeout=15s get pods -n kube-system 2>/dev/null | grep -qE 'calico|flannel|cilium|weave'; then
  installed=1
fi

if kubectl --request-timeout=15s get daemonset -A 2>/dev/null | grep -qE 'calico|flannel|cilium|weave'; then
  installed=1
fi

if [ "$installed" -ne 1 ]; then
  echo "No supported CNI installation detected."
  echo "Expected: tigera-operator namespace, calico-system namespace, or CNI pods in kube-system."
  echo "Try: kubectl --request-timeout=15s create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.4/manifests/tigera-operator.yaml"
  exit 1
fi

if kubectl --request-timeout=15s get nodes --no-headers 2>/dev/null | awk '$2 != "Ready"' | grep -q .; then
  echo "One or more nodes are not Ready after CNI install"
  kubectl --request-timeout=15s get nodes
  exit 1
fi

echo "PASS"
exit 0
