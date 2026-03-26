#!/usr/bin/env bash
# Shared initialization helpers for project scripts.
# Source this file: source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
# The calling script must set REPO_ROOT before sourcing.

set -euo pipefail

ensure_submodules() {
  local submodule_dir="${REPO_ROOT}/src/nfw"
  if [ ! -f "${submodule_dir}/.git" ]; then
    echo "📦 Initializing git submodules..."
    git -C "${REPO_ROOT}" submodule update --init --recursive --quiet
  else
    echo "📦 Submodules already initialized."
  fi

  # Ensure nested submodules inside nfw are also initialized
  if [ -f "${submodule_dir}/.git" ]; then
    local nested_missing=false
    for nested in packages/n-framework-core-cli packages/n-framework-core-template packages/nfw-templates; do
      if [ ! -f "${submodule_dir}/${nested}/.git" ]; then
        nested_missing=true
        break
      fi
    done
    if [ "$nested_missing" = true ]; then
      echo "📦 Initializing nested submodules in src/nfw..."
      git -C "${submodule_dir}" submodule update --init --recursive --quiet
    fi
  fi
}

ensure_tools() {
  echo "🔧 Restoring .NET tools..."
  dotnet tool restore --verbosity quiet --tool-manifest "${REPO_ROOT}/.config/dotnet-tools.json"
}

ensure_dotfiles() {
  local src_dir="${REPO_ROOT}/src"

  echo "📄 Syncing dotfiles to src/ subprojects..."
  for project in "$src_dir"/*/; do
    [ -d "$project" ] || continue
    local name="$(basename "$project")"

    # LICENSE → all subprojects
    if [ -f "${REPO_ROOT}/LICENSE" ]; then
      if [ ! -f "${project}LICENSE" ] || ! cmp -s "${REPO_ROOT}/LICENSE" "${project}LICENSE"; then
        cp "${REPO_ROOT}/LICENSE" "${project}LICENSE"
        echo "  ✔ LICENSE → ${name}"
      fi
    fi

    # .csharpierrc / .editorconfig → C# projects only
    local is_csharp=false
    if find "$project" -maxdepth 4 -name '*.csproj' -print -quit | grep -q .; then
      is_csharp=true
    fi
    if [ "$is_csharp" = true ]; then
      for file in .csharpierrc .editorconfig; do
        if [ -f "${REPO_ROOT}/${file}" ]; then
          if [ ! -f "${project}${file}" ] || ! cmp -s "${REPO_ROOT}/${file}" "${project}${file}"; then
            cp "${REPO_ROOT}/${file}" "${project}${file}"
            echo "  ✔ ${file} → ${name}"
          fi
        fi
      done
    fi
  done
}

init_environment() {
  ensure_submodules
  ensure_dotfiles
  ensure_tools
}
