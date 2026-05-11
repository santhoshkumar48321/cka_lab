## Scenario
Istio service mesh CRDs are installed on this cluster. A new team member needs documentation explaining what resources are available and what the key fields do. You need to discover and capture this information using kubectl's built-in tools.

## Goal
List all Istio CRDs and extract schema documentation for `VirtualService.spec.hosts`.

## What exists in the cluster when you start

| Resource | Type | Notes |
|---|---|---|
| `virtualservices.networking.istio.io` | CRD | short name: `vs` |
| `destinationrules.networking.istio.io` | CRD | short name: `dr` |
| `gateways.networking.istio.io` | CRD | — |
| `serviceentries.networking.istio.io` | CRD | — |

## Requirements
1. List all Istio CRDs and save to `~/crds-list.yaml`
2. Extract `kubectl explain` output for `VirtualService.spec.hosts` and save to `~/hosts-spec.yaml`
