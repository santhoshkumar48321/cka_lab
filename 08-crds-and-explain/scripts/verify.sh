#!/usr/bin/env bash
set -euo pipefail

crds_file="$HOME/crds-list.txt"
subject_file="$HOME/subject-explain.txt"

if ! test -s "$crds_file"; then
  echo "Missing or empty file: $crds_file"
  exit 1
fi

if ! grep -q 'cert-manager.io' "$crds_file"; then
  echo "$crds_file must contain cert-manager.io CRD entries"
  exit 1
fi

if ! test -s "$subject_file"; then
  echo "Missing or empty file: $subject_file"
  exit 1
fi

if ! grep -qi 'subject\|Certificate' "$subject_file"; then
  echo "$subject_file must contain kubectl explain output for Certificate.spec.subject"
  exit 1
fi

echo "PASS"
exit 0
