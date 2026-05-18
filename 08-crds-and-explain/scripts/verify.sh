#!/usr/bin/env bash
set -euo pipefail

if ! test -s /root/crds-list.txt; then
  echo "Missing or empty: ~/crds-list.txt"
  exit 1
fi

if ! grep -q 'cert-manager.io' /root/crds-list.txt; then
  echo "~/crds-list.txt must contain cert-manager.io CRD entries"
  exit 1
fi

if ! test -s /root/subject-explain.txt; then
  echo "Missing or empty: ~/subject-explain.txt"
  exit 1
fi

if ! grep -qi 'subject\|Certificate' /root/subject-explain.txt; then
  echo "~/subject-explain.txt must contain kubectl explain output for Certificate.spec.subject"
  exit 1
fi

echo "PASS"
exit 0
