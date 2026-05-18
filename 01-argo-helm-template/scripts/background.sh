#!/usr/bin/env bash
set -euo pipefail

wait_kube() {
  for i in $(seq 1 60); do
    if kubectl get ns >/dev/null 2>&1; then
      return 0
    fi
    sleep 1
  done
  echo "Kubernetes API not ready after 60 seconds" >&2
  exit 1
}

wait_kube

mkdir -p /home/candidate

if ! command -v helm >/dev/null 2>&1; then
  installer="/tmp/get-helm-3.sh"
  curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 -o "$installer"
  if ! bash "$installer"; then
    echo "Failed to install helm" >&2
    exit 1
  fi
  rm -f "$installer"
fi

helm repo add argo https://argoproj.github.io/argo-helm 2>/dev/null || true
helm repo update 2>/dev/null || true

kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

echo "Pre-rendering Argo CD CRDs (this takes ~30s)..."
helm template argocd-pre argo/argo-cd \
  --version 8.0.17 \
  --namespace argocd \
  --include-crds \
  > /tmp/argocd-full.yaml

awk '
  /^---/ { if (is_crd && doc!="") {print "---"; printf "%s",doc} is_crd=0; doc="" }
  /kind: CustomResourceDefinition/ { is_crd=1 }
  { doc=doc $0 "\n" }
  END { if (is_crd && doc!="") {print "---"; printf "%s",doc} }
' /tmp/argocd-full.yaml | kubectl apply --server-side -f - 2>/dev/null || true

echo "Argo CD CRDs pre-installed."
rm -f /tmp/argocd-full.yaml

echo "Setup complete"
