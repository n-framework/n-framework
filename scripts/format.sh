#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
# shellcheck source=./scripts/common.sh
source "${SCRIPT_DIR}/common.sh"

init_environment

cd "$REPO_ROOT"

echo -e "\n🔧 Fixing code style violations..."
while IFS= read -r -d '' slnx_file; do
  echo "  📋 Formatting $(basename "$slnx_file")..."
  dotnet format "$slnx_file"
done < <(find "$REPO_ROOT" -name "*.slnx" -type f -print0)

echo "🎨 Formatting C# code with CSharpier..."
dotnet csharpier format .

echo -e "\n✨ Formatting text files with Prettier..."
bun prettier --write "**/*.{md,json,yml,yaml,css,html,ts,js,tsx,jsx}"

echo -e "\n🐚 Formatting shell scripts with shfmt..."
shfmt -w -i 2 -sr -ci -ln bash "$REPO_ROOT"/scripts

echo -e "\n✨ Formatting complete!"
