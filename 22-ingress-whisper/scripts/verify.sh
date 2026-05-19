#!/usr/bin/env bash
set -euo pipefail

if ! kubectl --request-timeout=15s get ingress stream-route -n media-zone >/dev/null 2>&1; then
  echo "Ingress 'stream-route' not found in namespace 'media-zone'"
  exit 1
fi

ing_yaml="$(kubectl --request-timeout=15s get ingress stream-route -n media-zone -o yaml)"

if ! echo "$ing_yaml" | grep -q 'media.demo.local'; then
  echo "Ingress host must be 'media.demo.local'"
  exit 1
fi

if ! echo "$ing_yaml" | grep -q '/stream'; then
  echo "Ingress must route path '/stream'"
  exit 1
fi

if ! echo "$ing_yaml" | grep -q 'name: mediaserver-svc'; then
  echo "Ingress must route to service 'mediaserver-svc'"
  exit 1
fi

if ! echo "$ing_yaml" | grep -q 'number: 8443'; then
  echo "Ingress must route to service port 8443"
  exit 1
fi

if ! echo "$ing_yaml" | grep -q 'tls:'; then
  echo "Ingress must define a TLS section"
  exit 1
fi

if ! echo "$ing_yaml" | grep -q 'secretName: media-tls'; then
  echo "Ingress TLS must reference secret 'media-tls'"
  exit 1
fi

echo "PASS"
exit 0
