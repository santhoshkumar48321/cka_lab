#!/usr/bin/env bash
set -euo pipefail

# Check that Gateway API or Calico/CNI pods are present in system namespaces
# Either tigera-operator OR calico-system OR calico-node on a kube-system daemonset indicates success
if kubectl get namespace tigera-operator >/dev/null 2>&1; then
  echo "PASS (tigera-operator namespace found)"
  exit 0
fi

if kubectl get namespace calico-system >/dev/null 2>&1; then
  echo "PASS (calico-system namespace found)"
  exit 0
fi

if kubectl get pods -n kube-system 2>/dev/null | grep -qE 'calico|flannel|cilium|weave'; then
  echo "PASS (CNI pods found in kube-system)"
  exit 0
fi

if kubectl get daemonset -A 2>/dev/null | grep -qE 'calico|flannel|cilium|weave'; then
  echo "PASS (CNI daemonset found)"
  exit 0
fi

echo "No supported CNI installation detected."
echo "Expected: tigera-operator namespace, calico-system namespace, or CNI pods in kube-system."
echo "Try: kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.4/manifests/tigera-operator.yaml"
exit 1
