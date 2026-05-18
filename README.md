# CKA Lab Platform for KillerCoda

Production-ready, exam-style Kubernetes labs for CKA preparation.

## What this repository provides

- Isolated, folder-based scenarios (`XX-scenario-name/`)
- Per-scenario environment bootstrap (`scripts/background.sh`)
- Per-scenario validation (`scripts/verify.sh`)
- KillerCoda course navigation via `structure.json`
- Automated repository validation and scenario indexing tools

## Repository layout

```text
cka_lab/
├── structure.json
├── tools/
│   ├── generate_structure.py
│   ├── validate_repository.py
│   └── validate.sh
└── XX-scenario-name/
    ├── index.json
    ├── intro.md
    ├── step1.md
    ├── finish.md
    └── scripts/
        ├── background.sh
        └── verify.sh
```

## Quick start (KillerCoda)

1. Fork this repository.
2. In KillerCoda Creator, connect your fork.
3. Ensure `structure.json` is at repository root.
4. Launch any scenario from the generated scenario list.

## Local validation

From repository root (`/home/runner/work/cka_lab/cka_lab`):

```bash
# Validate all scenarios, config references, scripts, and structure index
./tools/validate.sh

# Rebuild structure.json from discovered scenario folders
python3 ./tools/generate_structure.py
```

## Authoring standards for new scenarios

Each new scenario must include:

- `index.json` with valid `details.intro`, `details.steps[0]`, `details.finish`, and `backend.imageid`
- `intro.md`, `step1.md`, `finish.md`
- `scripts/background.sh` and `scripts/verify.sh` with:
  - `#!/usr/bin/env bash`
  - `set -euo pipefail`
  - idempotent setup and checks

## Contribution workflow

1. Create a new `XX-scenario-name` folder.
2. Add/modify scenario content and scripts.
3. Run `./tools/validate.sh`.
4. Run `python3 ./tools/generate_structure.py` if scenarios were added/renamed.
5. Submit PR.

## Platform reliability guidance

- Keep bootstrap scripts idempotent (`--dry-run=client -o yaml | kubectl apply -f -` when applicable).
- Keep verifiers deterministic and failure-first (`echo reason && exit 1`).
- Prefer explicit namespaces and explicit API versions.
- Avoid hidden dependencies between scenarios.

## Scaling guidance

- Add future labs by following numeric folder naming.
- Keep scenario files self-contained and reproducible.
- Use `tools/validate_repository.py` as the quality gate in CI.

