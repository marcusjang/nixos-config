#! /usr/bin/env bash

set -euo pipefail

target="${1:-@}"
action="${2:-boot}"

# Use colors only when stderr is a terminal and NO_COLOR isn't set
# shellcheck disable=SC2034
if [[ -t 2 && -z "${NO_COLOR:-}" ]]; then
	RESET=$'\e[0m' BOLD=$'\e[1m' DIM=$'\e[2m'
	RED=$'\e[31m' GREEN=$'\e[32m' YELLOW=$'\e[33m' BLUE=$'\e[34m'
	MAGENTA=$'\e[35m'
else
	RESET='' BOLD='' DIM='' RED='' GREEN='' YELLOW='' BLUE=''
	MAGENTA=''
fi

function _log() {  # usage: _log <color> <label> <message...>
	local color=$1 label=$2
	shift 2
	printf '%s%s%s: %s\n' "${color}${BOLD}" "$label" "$RESET" "$*" >&2
}

function info()      { _log "$YELLOW" "info"     "$@"; }
function build_msg() { _log "$GREEN"  "building" "$@"; }
function copy_msg()  { _log "$BLUE"   "copying"  "$@"; }
function error()     { _log "$RED"    "error"    "$@"; }
function debug()     { [[ -n "${DEBUG:-}" ]] && _log "$MAGENTA" "debug" "$@"; return 0; }
function die()       { error "$@"; exit 1; }

function normalize_pwd() {
	dirname=$(dirname "$0")
	cd "$dirname/.." || exit
}

function main() {
	normalize_pwd

	debug "Pulling from Git repository..."
	git pull --quiet

	rebuild_args=(
		--option warn-dirty false
		--sudo
		--ask-sudo-password
		--flake .
	)

	if [[ "$target" == "@" ]]; then
		info "Rebuilding local system configurations..."
	else
		rebuild_args+=(--target-host "$target")
		info "Rebuilding remote system configurations on $target..."	
	fi

	case "$action" in
		switch|boot|test|build|dry-build|dry-activate|edit|build-vm|build-vm-with-bootloader|build-image|list-generations)
			rebuild_args+=("$action")
			info "Action = $action"
			exec nixos-rebuild "${rebuild_args[@]}"
			;;
		*)
			echo "Usage: $0 {host|@} {switch|boot|test|build|dry-build|dry-activate|edit|build-vm|build-vm-with-bootloader|build-image|list-generations} [args]" >&2
			exit 1
			;;
	esac
}

main "$@"
