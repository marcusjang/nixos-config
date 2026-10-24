#! /usr/bin/env bash

set -euo pipefail

# Use colors only when stderr is a terminal and NO_COLOR isn't set
# shellcheck disable=SC2034
if [[ -t 2 && -z "${NO_COLOR:-}" ]]; then
	RESET=$'\e[0m' BOLD=$'\e[1m' DIM=$'\e[2m'
	RED=$'\e[31m' GREEN=$'\e[32m' YELLOW=$'\e[33m' BLUE=$'\e[34m'
	MAGENTA=$'\e[35m' CYAN=$'\e[36m'
else
	RESET='' BOLD='' DIM='' RED='' GREEN='' YELLOW='' BLUE=''
	MAGENTA='' CYAN=''
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

	debug "Checking Git diff-index of the current HEAD"
	git diff-index --quiet HEAD -- >/dev/null 2>&1; ec=$?

	if test "$ec" = 0; then
		debug "Exit code was 0 with no diff, commencing flake update..."
		nix flake update
		debug "Flake update was successful, Adding git commit..."
		git add flake.lock
		git commit -m "Update flake inputs"
	elif test "$ec" = 1; then
		debug "Exit code was 1 with differences, exiting..."
		exit
	else
		die "Error from diff-index, cancelling..."
	fi
}

main "$@"
