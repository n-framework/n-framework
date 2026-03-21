#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$ROOT_DIR"

echo -e "\n🔧 Fixing code style violations..."
# Find and format all .slnx files
while IFS= read -r -d '' slnx_file; do
	echo "  📋 Formatting $(basename "$slnx_file")..."
	dotnet format "$slnx_file"
done < <(find "$ROOT_DIR" -name "*.slnx" -type f -print0)

echo "🎨 Formatting C# code with CSharpier..."
dotnet csharpier format .

echo -e "\n✨ Formatting text files with Prettier..."
bun prettier --write "**/*.{md,json,yml,yaml,css,html,ts,js,tsx,jsx}"

echo -e "\n✨ Formatting complete!"
