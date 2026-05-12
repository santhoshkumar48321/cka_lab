## Scenario
A production node has been tainted to reserve it exclusively for production workloads. You need to schedule a pod that tolerates this taint so it can land on the reserved node.

## Goal
Reserve a node for production workloads using a taint, then schedule a pod that tolerates it.

## What you'll see when the lab starts
A node already has the taint `Env=Production:NoSchedule` applied. Your task is to create a pod that can schedule onto that tainted node.

## Requirements
- Find the node that carries taint `Env=Production:NoSchedule`
- Pod name: `prod-pod`
- Image: `nginx:latest`
- Pod must have a toleration for `Env=Production:NoSchedule`
- Pod must be in **Running** state
