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

# Pre-add the argo helm repo
helm repo add argo https://argoproj.github.io/argo-helm 2>/dev/null || true
helm repo update 2>/dev/null || true

# ── Pre-install Argo CD CRDs ──────────────────────────────────────────────────
# Simulates a production cluster where Argo CD CRDs are already present.
# The candidate's Step 5 applies the no-CRDs manifest to this cluster.
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

echo "Pre-rendering Argo CD CRDs (this takes ~30s)..."
helm template argocd-pre argo/argo-cd \
  --version 8.0.17 \
  --namespace argocd \
  --include-crds \
  > /tmp/argocd-full.yaml

# Extract only CRD documents and apply them server-side
python3 - <<'PY'
content = open('/tmp/argocd-full.yaml').read()
docs = content.split('\n---')
crds = [d for d in docs if 'kind: CustomResourceDefinition' in d]
print('\n---'.join(crds))
PY | kubectl apply --server-side -f -

echo "Argo CD CRDs pre-installed."
rm -f /tmp/argocd-full.yaml

echo "Setup complete"
