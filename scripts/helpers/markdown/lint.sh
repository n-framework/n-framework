#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=packages/acore-scripts/src/logger.sh
source "${SCRIPT_DIR}/../../../packages/acore-scripts/src/logger.sh"

REPO_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"
cd "$REPO_ROOT"

acore_log_section "🔍 Linting markdown files with markdownlint-cli2..."

errors=$(bun run markdownlint-cli2 "src/**/*.md" "docs/**/*.md" "specs/**/*.md" 2>&1 | grep -v "markdownlint-cli2" | grep -v "^Finding:" | grep -v "^Linting:" | grep -v "^Summary:" || true)

if [ -n "$errors" ]; then
	printf '%s\n' "$errors"
	exit 1
fi

acore_log_success "✨ Markdown linting complete!"
