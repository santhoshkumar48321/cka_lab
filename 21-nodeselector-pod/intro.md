## Scenario
Your cluster has nodes with SSD storage labeled accordingly. You need to ensure a specific pod lands only on those SSD-backed nodes by using a nodeSelector.

## Goal
Schedule a Pod onto nodes labeled for SSD storage.

## Requirements
- Pod name: `nginx-kusc01801`
- Image: `nginx:1.27`
- Node selector: `disk=ssd`
