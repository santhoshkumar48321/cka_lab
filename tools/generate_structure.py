#!/usr/bin/env python3
"""Generate Killercoda structure.json from scenario folders."""

from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SCENARIO_PATTERN = re.compile(r"^\d{2}-")


def scenario_dirs() -> list[Path]:
    dirs = [p for p in ROOT.iterdir() if p.is_dir() and SCENARIO_PATTERN.match(p.name)]
    return sorted(dirs, key=lambda p: p.name)


def load_index_title(path: Path) -> str:
    index_path = path / "index.json"
    data = json.loads(index_path.read_text(encoding="utf-8"))
    return data.get("title", path.name)


def normalize_description(title: str) -> str:
    if ":" in title:
        return title.split(":", 1)[1].strip()
    return title.strip()


def main() -> None:
    items = []
    for scenario in scenario_dirs():
        title = load_index_title(scenario)
        prefix = scenario.name.split("-", 1)[0]
        items.append(
            {
                "path": scenario.name,
                "title": f"{prefix} - {title}",
                "description": normalize_description(title),
            }
        )

    output = {
        "title": "CKA 2026 Real-World Labs (35 Scenarios)",
        "description": "Exam-style Kubernetes Administrator scenarios with guided tasks, resets, and verification.",
        "items": items,
    }

    target = ROOT / "structure.json"
    target.write_text(json.dumps(output, indent=2) + "\n", encoding="utf-8")
    print(f"Wrote {target} with {len(items)} scenarios")


if __name__ == "__main__":
    main()
