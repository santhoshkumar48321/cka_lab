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

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.1/deploy/static/provider/baremetal/deploy.yaml

controller_phase=""
for i in $(seq 1 90); do
  controller_phase="$(kubectl get pods -n ingress-nginx -l app.kubernetes.io/component=controller -o jsonpath='{.items[0].status.phase}' 2>/dev/null || echo "")"
  if test "$controller_phase" = "Running"; then
    break
  fi
  sleep 1
done

if ! test "$controller_phase" = "Running"; then
  echo "Ingress controller not ready after 90 seconds" >&2
  exit 1
fi

kubectl create -f - --dry-run=client -o yaml <<'YAML' | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: IngressClass
metadata:
  name: nginx
  annotations:
    ingressclass.kubernetes.io/is-default-class: "true"
spec:
  controller: k8s.io/ingress-nginx
YAML

kubectl create namespace demo-app --dry-run=client -o yaml | kubectl apply -f -

kubectl create -f - --dry-run=client -o yaml <<'YAML' | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app
  namespace: demo-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: app
  template:
    metadata:
      labels:
        app: app
    spec:
      containers:
      - name: app
        image: nginx:latest
        ports:
        - containerPort: 80
YAML

echo "Setup complete"
