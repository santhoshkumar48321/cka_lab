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

# ── Install a representative set of Istio CRDs inline (no network dependency) ──
kubectl apply -f - <<'YAML'
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: virtualservices.networking.istio.io
spec:
  group: networking.istio.io
  versions:
  - name: v1beta1
    served: true
    storage: true
    schema:
      openAPIV3Schema:
        type: object
        properties:
          spec:
            type: object
            description: "Configuration affecting label/content routing, gateways, and TLS SNI."
            properties:
              hosts:
                description: "The destination hosts to which traffic is being sent. Could be a DNS name with wildcard prefix or an IP address. Depending on the platform, short-names can also be used instead of a FQDN."
                type: array
                items:
                  type: string
              gateways:
                description: "The names of gateways and sidecars that should apply these rules."
                type: array
                items:
                  type: string
              http:
                description: "An ordered list of route rules for HTTP traffic."
                type: array
                items:
                  type: object
                  x-kubernetes-preserve-unknown-fields: true
  scope: Namespaced
  names:
    plural: virtualservices
    singular: virtualservice
    kind: VirtualService
    shortNames:
    - vs
---
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: destinationrules.networking.istio.io
spec:
  group: networking.istio.io
  versions:
  - name: v1beta1
    served: true
    storage: true
    schema:
      openAPIV3Schema:
        type: object
        x-kubernetes-preserve-unknown-fields: true
  scope: Namespaced
  names:
    plural: destinationrules
    singular: destinationrule
    kind: DestinationRule
    shortNames:
    - dr
---
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: gateways.networking.istio.io
spec:
  group: networking.istio.io
  versions:
  - name: v1beta1
    served: true
    storage: true
    schema:
      openAPIV3Schema:
        type: object
        x-kubernetes-preserve-unknown-fields: true
  scope: Namespaced
  names:
    plural: gateways
    singular: gateway
    kind: Gateway
---
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: serviceentries.networking.istio.io
spec:
  group: networking.istio.io
  versions:
  - name: v1beta1
    served: true
    storage: true
    schema:
      openAPIV3Schema:
        type: object
        x-kubernetes-preserve-unknown-fields: true
  scope: Namespaced
  names:
    plural: serviceentries
    singular: serviceentry
    kind: ServiceEntry
YAML

echo "Setup complete"
