#!/usr/bin/env bash

set -euo pipefail

_HELPER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=packages/acore-scripts/src/logger.sh
source "${_HELPER_DIR}/../../packages/acore-scripts/src/logger.sh"

REPO_ROOT="$(cd "${_HELPER_DIR}/../.." && pwd)"

sync_acore_scripts() {
	local acore_path="packages/acore-scripts"
	local acore_full="${REPO_ROOT}/${acore_path}"

	if [ ! -e "$acore_full/.git" ] && [ ! -f "$acore_full/.git" ]; then
		if git -C "$REPO_ROOT" config --file .gitmodules --get "submodule.${acore_path}.path" &> /dev/null; then
			acore_log_section "📦 Initializing acore-scripts submodule..."
			git -C "$REPO_ROOT" submodule update --init "$acore_path"
		else
			acore_log_section "📦 Adding acore-scripts submodule..."
			git -C "$REPO_ROOT" submodule add git@github.com:ahmet-cetinkaya/acore-scripts.git "$acore_path"
		fi
	else
		acore_log_success "✅ acore-scripts submodule ready."
	fi
}

sync_project_acore_scripts() {
	local project="$1"
	local name="$2"
	local acore_path="packages/acore-scripts"
	local acore_full="${project}${acore_path}"

	# Already a working submodule (has .git file or directory).
	if [ -e "$acore_full/.git" ] || [ -f "$acore_full/.git" ]; then
		acore_log_success "✅ acore-scripts ready in ${name}."
		return 0
	fi

	# Directory exists with files but is not a submodule — skip.
	if [ -d "$acore_full" ] && [ "$(ls -A "$acore_full" 2> /dev/null)" ]; then
		acore_log_success "✅ acore-scripts ready in ${name}."
		return 0
	fi

	if git -C "$project" config --file .gitmodules --get "submodule.${acore_path}.path" &> /dev/null; then
		acore_log_info "📦 Initializing acore-scripts in ${name}..."
		git -C "$project" submodule update --init "$acore_path"
	else
		acore_log_info "📦 Adding acore-scripts to ${name}..."
		git -C "$project" submodule add git@github.com:ahmet-cetinkaya/acore-scripts.git "$acore_path"
	fi
}

sync_scripts() {
	sync_acore_scripts

	local src_dir="${REPO_ROOT}/src"
	local helpers="${REPO_ROOT}/scripts/helpers"
	local scripts_dir="${REPO_ROOT}/scripts"

	if [ ! -d "$src_dir" ] || [ ! -d "$helpers" ]; then
		return 0
	fi

	acore_log_section "📄 Syncing scripts to src/ subprojects..."

	for project in "$src_dir"/*/; do
		[ -d "$project" ] || continue
		local name
		name="$(basename "$project")"

		sync_project_acore_scripts "$project" "$name"

		local project_scripts="${project}scripts"
		mkdir -p "$project_scripts"

		for helper_dir in "$helpers"/*/; do
			[ -d "$helper_dir" ] || continue
			local dir_name
			dir_name="$(basename "$helper_dir")"

			local should_sync=false

			case "$dir_name" in
				rust)
					if [ -f "${project}Cargo.toml" ]; then
						should_sync=true
					fi
					;;
				csharp)
					if [ -n "$(fd -e csproj -d 4 . "$project" 2> /dev/null)" ]; then
						should_sync=true
					fi
					;;
				shell)
					if fd -e sh -t f . "$project" &> /dev/null; then
						should_sync=true
					fi
					;;
				markdown)
					if fd -e md -t f . "$project" &> /dev/null; then
						should_sync=true
					fi
					;;
			esac

			if [ "$should_sync" = true ]; then
				local dest="${project_scripts}/helpers/${dir_name}"
				mkdir -p "$dest"
				cp -r "${helper_dir}/." "$dest/"
				acore_log_success "✅ helpers/${dir_name}/ → ${name}"
			fi
		done

		if [ -f "${scripts_dir}/format.sh" ]; then
			cp "${scripts_dir}/format.sh" "$project_scripts/format.sh"
			acore_log_success "✅ format.sh → ${name}"
		fi

		if [ -f "${scripts_dir}/lint.sh" ]; then
			cp "${scripts_dir}/lint.sh" "$project_scripts/lint.sh"
			acore_log_success "✅ lint.sh → ${name}"
		fi
	done
}
