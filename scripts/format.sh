#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$ROOT_DIR"

echo "Formatting C# code with CSharpier..."
dotnet csharpier format .

echo ""
echo "Formatting text files with Prettier..."
bun prettier --write "**/*.{md,json,yml,yaml,css,html,ts,js,tsx,jsx}"

echo ""
echo "Formatting complete!"
