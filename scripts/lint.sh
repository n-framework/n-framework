#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=packages/acore-scripts/src/logger.sh
source "${SCRIPT_DIR}/../packages/acore-scripts/src/logger.sh"

REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "$REPO_ROOT"

for helper_lint in "${SCRIPT_DIR}/helpers"/*/lint.sh; do
	[ -f "$helper_lint" ] || continue
	bash "$helper_lint"
done

for project_lint in "${REPO_ROOT}"/src/*/scripts/lint.sh; do
	[ -f "$project_lint" ] || continue
	project_name="$(basename "$(dirname "$(dirname "$project_lint")")")"
	acore_log_header "▶️ Running lint in src/$project_name..."
	bash "$project_lint"
done

acore_log_divider
acore_log_success "🔍 All linting has completed!"
