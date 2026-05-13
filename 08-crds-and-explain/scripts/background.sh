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

kubectl create -f - --dry-run=client -o yaml <<'YAML' | kubectl apply -f -
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: certificates.cert-manager.io
spec:
  group: cert-manager.io
  versions:
  - name: v1
    served: true
    storage: true
    schema:
      openAPIV3Schema:
        type: object
        properties:
          spec:
            type: object
            properties:
              subject:
                type: object
                description: "Subject distinguished name fields (organization, country, locality, etc.) used when issuing the certificate."
                properties:
                  organizations:
                    type: array
                    items:
                      type: string
                  countries:
                    type: array
                    items:
                      type: string
                  organizationalUnits:
                    type: array
                    items:
                      type: string
                  localities:
                    type: array
                    items:
                      type: string
                  provinces:
                    type: array
                    items:
                      type: string
                  streetAddresses:
                    type: array
                    items:
                      type: string
                  postalCodes:
                    type: array
                    items:
                      type: string
  scope: Namespaced
  names:
    plural: certificates
    singular: certificate
    kind: Certificate
---
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: issuers.cert-manager.io
spec:
  group: cert-manager.io
  versions:
  - name: v1
    served: true
    storage: true
    schema:
      openAPIV3Schema:
        type: object
        x-kubernetes-preserve-unknown-fields: true
  scope: Namespaced
  names:
    plural: issuers
    singular: issuer
    kind: Issuer
---
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: clusterissuers.cert-manager.io
spec:
  group: cert-manager.io
  versions:
  - name: v1
    served: true
    storage: true
    schema:
      openAPIV3Schema:
        type: object
        x-kubernetes-preserve-unknown-fields: true
  scope: Cluster
  names:
    plural: clusterissuers
    singular: clusterissuer
    kind: ClusterIssuer
---
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: certificaterequests.cert-manager.io
spec:
  group: cert-manager.io
  versions:
  - name: v1
    served: true
    storage: true
    schema:
      openAPIV3Schema:
        type: object
        x-kubernetes-preserve-unknown-fields: true
  scope: Namespaced
  names:
    plural: certificaterequests
    singular: certificaterequest
    kind: CertificateRequest
YAML

echo "Setup complete"
