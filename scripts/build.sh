#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
# shellcheck source=./scripts/common.sh
source "${SCRIPT_DIR}/common.sh"

init_environment

echo "🔨 Building project..."
make -C "${REPO_ROOT}/src/nfw" build

echo "✅ Build complete!"
