#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FAILURES=0

cd "$ROOT_DIR"

echo "Running Roslynator analysis..."

for sln in $(find . -name "*.sln" -type f); do
  echo ""
  echo "Analyzing $sln..."
  if ! dotnet roslynator analyze "$sln"; then
    FAILURES=$((FAILURES + 1))
  fi
done

# Also analyze all projects directly if no solutions found
if [[ -z $(find . -name "*.sln" -type f) ]]; then
  echo "No solutions found, analyzing projects..."
  for csproj in $(find . -name "*.csproj" -type f); do
    echo ""
    echo "Analyzing $csproj..."
    if ! dotnet roslynator analyze "$csproj"; then
      FAILURES=$((FAILURES + 1))
    fi
  done
fi

echo ""
if [[ $FAILURES -gt 0 ]]; then
  echo "Lint failed: $FAILURES project(s) had issues"
  exit 1
fi

echo "Lint passed"
