#!/usr/bin/env bash
# Prepare the development environment.
# Ensures submodules, tool availability, dotfile sync, and npm deps.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../packages/acore-scripts/src/logger.sh"

# shellcheck source=./helpers/submodules.sh
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/helpers/submodules.sh"

# shellcheck source=./helpers/dotfiles.sh
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/helpers/dotfiles.sh"

# shellcheck source=./helpers/tools.sh
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/helpers/tools.sh"

# shellcheck source=./helpers/sync.sh
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/helpers/sync.sh"

# shellcheck source=./helpers/makefile.sh
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/helpers/makefile.sh"

OVERRIDE=false
for arg in "$@"; do
	case "$arg" in
	--override) OVERRIDE=true ;;
	esac
done

if [ "$OVERRIDE" = true ]; then
	acore_log_info "Running in override mode..."
fi

acore_log_info "Running in override mode..."

ensure_submodules
sync_dotfiles
ensure_tools
sync_scripts
ensure_project_makefiles

# Special improvement for dotnet-service template .editorconfig
cp "${REPO_ROOT}/.editorconfig" "${REPO_ROOT}/src/nfw-generators/src/dotnet-service/service/content/.editorconfig"
acore_log_success "✅ .editorconfig improved for dotnet-service template"

acore_log_success "✨ Dev environment ready!"
