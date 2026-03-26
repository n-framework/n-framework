#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
# shellcheck source=./scripts/common.sh
source "${SCRIPT_DIR}/common.sh"

init_environment

cd "$REPO_ROOT"

echo "📦 Checking for outdated dependencies..."

# Check solutions (.slnx)
if [[ -n $(find . -name "*.slnx" -type f -print0) ]]; then
  find . -name "*.slnx" -type f -print0 | while IFS= read -r -d '' slnx; do
    echo -e "\n  📋 Checking $(basename "$slnx")..."
    dotnet dotnet-outdated "$slnx"
  done
else
  echo "📦 No solutions found, checking projects..."
  # Check projects (.csproj)
  find . -name "*.csproj" -type f -print0 | while IFS= read -r -d '' csproj; do
    echo -e "\n  📋 Checking $(basename "$csproj")..."
    dotnet dotnet-outdated "$csproj"
  done
fi
