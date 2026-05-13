#!/usr/bin/env bash
set -euo pipefail

if ! kubectl get storageclass local-storage >/dev/null 2>&1; then
  echo "StorageClass 'local-storage' not found"
  exit 1
fi

provisioner="$(kubectl get storageclass local-storage -o jsonpath='{.provisioner}')"
if ! test "$provisioner" = "rancher.io/local-path"; then
  echo "StorageClass provisioner must be 'rancher.io/local-path', got: $provisioner"
  exit 1
fi

vbm="$(kubectl get storageclass local-storage -o jsonpath='{.volumeBindingMode}')"
if ! test "$vbm" = "WaitForFirstConsumer"; then
  echo "StorageClass volumeBindingMode must be 'WaitForFirstConsumer', got: $vbm"
  exit 1
fi

ann="$(kubectl get storageclass local-storage -o jsonpath='{.metadata.annotations.storageclass\.kubernetes\.io/is-default-class}')"
if ! test "$ann" = "true"; then
  echo "StorageClass 'local-storage' must have is-default-class annotation set to true"
  exit 1
fi

if ! kubectl get pvc local-claim >/dev/null 2>&1; then
  echo "PVC 'local-claim' not found"
  exit 1
fi

pvc_phase="$(kubectl get pvc local-claim -o jsonpath='{.status.phase}')"
if ! test "$pvc_phase" = "Bound"; then
  echo "PVC 'local-claim' must be Bound, found: $pvc_phase"
  exit 1
fi

if ! kubectl get pod pvc-checker >/dev/null 2>&1; then
  echo "Pod 'pvc-checker' not found"
  exit 1
fi

pod_phase="$(kubectl get pod pvc-checker -o jsonpath='{.status.phase}')"
if ! test "$pod_phase" = "Running"; then
  echo "Pod 'pvc-checker' must be Running, found: $pod_phase"
  exit 1
fi

pod_claim="$(kubectl get pod pvc-checker -o jsonpath='{.spec.volumes[?(@.persistentVolumeClaim)].persistentVolumeClaim.claimName}')"
if ! test "$pod_claim" = "local-claim"; then
  echo "Pod 'pvc-checker' must use PVC 'local-claim', found: $pod_claim"
  exit 1
fi

echo "PASS"
exit 0
