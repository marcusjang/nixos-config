#! /usr/bin/env bash

set -euo pipefail

trap "break" SIGINT SIGHUP SIGTERM

CACHE_URL="${CACHE_URL:-ssh-ng://marcus@n5.local}"
FLAKE="${FLAKE:-.}"

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

	debug "Pulling from Git repository..."
	git pull --quiet

	HEAD=$(git rev-parse --short=8 HEAD)
	TIME=$(git show -s --format=%ci)

	info "Building $HEAD ($TIME)..."
	info "Local cache at: $CACHE_URL"

	readarray -t HOSTS < <(
		nix eval --raw "${FLAKE}#nixosConfigurations" \
			--apply 'cs: builtins.concatStringsSep "\n" (builtins.attrNames cs)'
	)

	debug "Following hosts are found in the flake:"
	if [[ -n "${DEBUG:-}" ]]; then
		for host in "${HOSTS[@]}"; do
			echo "  - $host"
		done	
	fi	

	for host in "${HOSTS[@]}"; do
		DERIVATION=".#nixosConfigurations.$host.config.system.build.toplevel"

		build_msg "Building $host..."
		nix build \
			--no-warn-dirty \
			--no-link \
			"$DERIVATION" \
		|| die "Build error, halting..."
		build_msg "Done!"

		copy_msg "Copying $host over to local cache..."
		nix copy \
			--no-warn-dirty \
			--to "$CACHE_URL" \
			--no-check-sigs \
			"$DERIVATION"
		copy_msg "Done!"
	done
}

main "$@"
