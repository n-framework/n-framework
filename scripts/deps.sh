#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$ROOT_DIR"

echo "Checking for outdated dependencies..."

# Check for solutions first
for sln in $(find . -name "*.sln" -type f); do
  echo ""
  echo "Checking $sln..."
  dotnet dotnet-outdated "$sln"
done

# If no solutions, check projects
if [[ -z $(find . -name "*.sln" -type f) ]]; then
  echo "No solutions found, checking projects..."
  for csproj in $(find . -name "*.csproj" -type f); do
    echo ""
    echo "Checking $csproj..."
    dotnet dotnet-outdated "$csproj"
  done
fi
