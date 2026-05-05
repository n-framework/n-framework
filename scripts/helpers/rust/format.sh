#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=packages/acore-scripts/src/logger.sh
source "${SCRIPT_DIR}/../../../packages/acore-scripts/src/logger.sh"

REPO_ROOT="$(cd "${SCRIPT_DIR}/../../.." && pwd)"
cd "$REPO_ROOT"

acore_log_section "🔧 Fixing Rust code with cargo clippy..."
fd -t f Cargo.toml . "$REPO_ROOT" | while read -r cargo_file; do
	cargo_dir="$(dirname "$cargo_file")"
	(cd "$cargo_dir" && cargo clippy --fix --allow-dirty --allow-staged &> /dev/null) || acore_log_warning "⚠️ Skipped $(basename "$cargo_dir")"
done

acore_log_section "🦀 Formatting Rust code with cargo fmt..."
fd -t f Cargo.toml . "$REPO_ROOT" | while read -r cargo_file; do
	cargo_dir="$(dirname "$cargo_file")"
	(cd "$cargo_dir" && cargo fmt &> /dev/null) || acore_log_warning "⚠️ Skipped $(basename "$cargo_dir")"
done

acore_log_success "✅ Rust formatting and linting complete!"
