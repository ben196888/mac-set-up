#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

bash "$SCRIPT_DIR/agentic_entry.sh" --all
bash "$SCRIPT_DIR/agentic_skills.sh" --all
bash "$SCRIPT_DIR/agentic_mcp.sh" --all
