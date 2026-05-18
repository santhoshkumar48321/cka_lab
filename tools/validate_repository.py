#!/usr/bin/env python3
"""Repository validator for Killercoda CKA labs."""

from __future__ import annotations

import json
import re
import stat
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SCENARIO_PATTERN = re.compile(r"^\d{2}-")
REQUIRED_FILES = [
    "index.json",
    "intro.md",
    "step1.md",
    "finish.md",
    "scripts/background.sh",
    "scripts/verify.sh",
]


def scenario_dirs() -> list[Path]:
    dirs = [p for p in ROOT.iterdir() if p.is_dir() and SCENARIO_PATTERN.match(p.name)]
    return sorted(dirs, key=lambda p: p.name)


def executable(path: Path) -> bool:
    return bool(path.stat().st_mode & stat.S_IXUSR)


def check_structure_json(scenarios: list[Path], errors: list[str]) -> None:
    structure = ROOT / "structure.json"
    try:
        data = json.loads(structure.read_text(encoding="utf-8"))
    except Exception as exc:
        errors.append(f"structure.json is invalid JSON: {exc}")
        return

    items = data.get("items", [])
    listed_paths = [item.get("path", "") for item in items]
    existing = [p.name for p in scenarios]

    missing = sorted(set(existing) - set(listed_paths))
    if missing:
        errors.append(f"structure.json missing scenarios: {', '.join(missing)}")

    extra = sorted(set(listed_paths) - set(existing))
    if extra:
        errors.append(f"structure.json has non-existent paths: {', '.join(extra)}")

    if len(listed_paths) != len(set(listed_paths)):
        errors.append("structure.json contains duplicate scenario paths")


def check_script_content(path: Path, script_type: str, errors: list[str], warnings: list[str]) -> None:
    text = path.read_text(encoding="utf-8")
    lines = text.splitlines()

    if not lines or lines[0].strip() != "#!/usr/bin/env bash":
        errors.append(f"{path}: first line must be '#!/usr/bin/env bash'")

    if "set -euo pipefail" not in text:
        errors.append(f"{path}: missing 'set -euo pipefail'")

    if script_type == "background.sh":
        if "wait_kube()" not in text:
            errors.append(f"{path}: missing wait_kube() helper")
        if "echo \"Setup complete\"" not in text:
            errors.append(f"{path}: missing final setup confirmation message")

    if script_type == "verify.sh":
        if "echo \"PASS\"" not in text:
            errors.append(f"{path}: missing final PASS message")
        if "exit 0" not in text:
            errors.append(f"{path}: missing explicit 'exit 0'")

    result = subprocess.run(["bash", "-n", str(path)], capture_output=True, text=True)
    if result.returncode != 0:
        errors.append(f"{path}: bash syntax error: {result.stderr.strip()}")

    if not executable(path):
        warnings.append(f"{path}: script is not executable")


def check_index_json(scenario: Path, errors: list[str]) -> None:
    index_path = scenario / "index.json"
    try:
        data = json.loads(index_path.read_text(encoding="utf-8"))
    except Exception as exc:
        errors.append(f"{index_path}: invalid JSON: {exc}")
        return

    details = data.get("details")
    if not isinstance(details, dict):
        errors.append(f"{index_path}: missing details block")
        return

    required_keys = [
        ("details.intro.text", details.get("intro", {}).get("text") if isinstance(details.get("intro"), dict) else None),
        ("details.intro.background", details.get("intro", {}).get("background") if isinstance(details.get("intro"), dict) else None),
        (
            "details.steps[0].text",
            details.get("steps", [{}])[0].get("text") if isinstance(details.get("steps"), list) and details.get("steps") else None,
        ),
        (
            "details.steps[0].verify",
            details.get("steps", [{}])[0].get("verify") if isinstance(details.get("steps"), list) and details.get("steps") else None,
        ),
        ("details.finish.text", details.get("finish", {}).get("text") if isinstance(details.get("finish"), dict) else None),
        ("backend.imageid", data.get("backend", {}).get("imageid") if isinstance(data.get("backend"), dict) else None),
    ]

    for key, value in required_keys:
        if not value:
            errors.append(f"{index_path}: missing {key}")

    for _, value in required_keys[:5]:
        if value and not (scenario / value).exists():
            errors.append(f"{index_path}: references missing file '{value}'")


def check_markdown_sections(scenario: Path, warnings: list[str]) -> None:
    intro = (scenario / "intro.md").read_text(encoding="utf-8")
    step = (scenario / "step1.md").read_text(encoding="utf-8")
    finish = (scenario / "finish.md").read_text(encoding="utf-8")

    if "## Scenario" not in intro or "## Goal" not in intro or "## Requirements" not in intro:
        warnings.append(f"{scenario.name}/intro.md: missing one or more recommended sections (Scenario/Goal/Requirements)")

    if "## Verify" not in step:
        warnings.append(f"{scenario.name}/step1.md: missing '## Verify' section")

    if "## Well done" not in finish:
        warnings.append(f"{scenario.name}/finish.md: missing '## Well done' section")


def main() -> int:
    errors: list[str] = []
    warnings: list[str] = []

    scenarios = scenario_dirs()
    if not scenarios:
        errors.append("No scenario directories were found (expected XX-<name> folders)")

    check_structure_json(scenarios, errors)

    for scenario in scenarios:
        for rel in REQUIRED_FILES:
            if not (scenario / rel).exists():
                errors.append(f"{scenario.name}: missing required file {rel}")

        if not errors:
            pass

        check_index_json(scenario, errors)

        bg = scenario / "scripts/background.sh"
        vf = scenario / "scripts/verify.sh"
        if bg.exists():
            check_script_content(bg, "background.sh", errors, warnings)
        if vf.exists():
            check_script_content(vf, "verify.sh", errors, warnings)

        if all((scenario / rel).exists() for rel in ["intro.md", "step1.md", "finish.md"]):
            check_markdown_sections(scenario, warnings)

    print(f"Scenarios discovered: {len(scenarios)}")
    if errors:
        print("\nERRORS:")
        for msg in errors:
            print(f"- {msg}")

    if warnings:
        print("\nWARNINGS:")
        for msg in warnings:
            print(f"- {msg}")

    if errors:
        print("\nRepository validation: FAILED")
        return 1

    print("\nRepository validation: PASSED")
    return 0


if __name__ == "__main__":
    sys.exit(main())
