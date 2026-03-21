#!/usr/bin/env bash
set -euo pipefail

# Allow .NET to roll forward to major versions (e.g., .NET 11 → .NET 10)
export DOTNET_ROLL_FORWARD=Major
export DOTNET_ROLL_FORWARD_TO_PRERELEASE=1

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FAILURES=0

cd "$ROOT_DIR"

# Find all projects once
PROJECTS=$(find . -name "*.csproj" -type f)

echo "🔍 Running Roslynator analysis..."
echo "⚠️ Roslynator doesn't support .slnx yet. Analyzing individual .csproj projects instead..."
for csproj in $PROJECTS; do
  echo -e "\n  📋 Analyzing $csproj..."
  if ! dotnet roslynator analyze "$csproj" --verbosity quiet; then
    FAILURES=$((FAILURES + 1))
  fi
done

echo -e "\n🔧 Building to check analyzer warnings (including suggestions and hints)..."

BUILD_HAS_SUGGESTIONS=false
for csproj in $PROJECTS; do
  echo -e "\n  📋 Building $csproj..."

  # Capture build output with quiet verbosity but still show warnings/errors
  BUILD_OUTPUT=$(dotnet build "$csproj" --verbosity quiet /p:WarningLevel=5 2>&1)
  BUILD_EXIT_CODE=$?

  # Show output only if there are warnings, errors, or failures
  if [ $BUILD_EXIT_CODE -ne 0 ] || echo "$BUILD_OUTPUT" | grep -qE "warning|error|IDE[0-9]+"; then
    echo "$BUILD_OUTPUT"
  fi

  # Check for build failures (warnings/errors)
  if [ $BUILD_EXIT_CODE -ne 0 ]; then
    FAILURES=$((FAILURES + 1))
  fi

  # Check for suggestions in output (IDE0xxx, CAxxxx, etc.)
  if echo "$BUILD_OUTPUT" | grep -qE "suggestion|hint|IDE[0-9]+"; then
    BUILD_HAS_SUGGESTIONS=true
  fi
done

# Report if suggestions were found (informational only)
if [ "$BUILD_HAS_SUGGESTIONS" = true ]; then
  echo -e "\n💡 Note: Some suggestions/hints were found in the build output above."
fi

echo -e "\n📝 Checking code style suggestions..."

for csproj in $PROJECTS; do
  echo -e "\n  📋 Checking $csproj..."
  # Check what style changes would be made (without applying them)
  if dotnet format style "$csproj" --verify-no-changes --verbosity quiet 2>&1; then
    echo "    No style suggestions"
  else
    echo "    ℹ️  Style suggestions found (run 'dotnet format style' to apply)"
  fi
done

echo -e "\n🎨 Checking .editorconfig formatting rules..."

for csproj in $PROJECTS; do
  echo -e "\n  📋 Checking $csproj..."
  if ! dotnet format --verify-no-changes "$csproj"; then
    FAILURES=$((FAILURES + 1))
  fi
done

echo -e "\n"
if [[ $FAILURES -gt 0 ]]; then
  echo "❌ Lint failed: $FAILURES project(s) had issues"
  exit 1
fi

echo "✅ Lint passed"
