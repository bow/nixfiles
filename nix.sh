#!/usr/bin/env bash

set -eo pipefail

REPO_DIR="$(dirname "$(readlink -f "$0")")"

show_usage() {
    cat <<__USAGE__
$(fmt_section "SYNOPSIS")
    $(fmt_name "$(basename "${0}")") $(fmt_subcommand "[rebuild|update|gc]")

    Helper script for common Nix tasks.

$(fmt_section "OPTIONS")
    $(fmt_subcommand "rebuild|r") $(fmt_param "machine")      \`nixos-rebuild --flake #.$(fmt_param "machine")\`
    $(fmt_subcommand "update|u") $(fmt_param "target")        \`nix flake update\`
    $(fmt_subcommand "gc")                     \`nix-store --gc\`
__USAGE__
}

run_rebuild() {
    machine=${1:-${HOSTNAME}}

    show_msg "Starting rebuild for machine=${machine}"
    sudo nixos-rebuild --flake "${REPO_DIR}"\#"${machine}" --fast switch
}

run_update() {
    target=${1}

    if [[ -z "${target}" ]]; then
        show_msg "Updating all inputs"
        nix flake update
    else
        show_msg "Updating input=${target}"
        nix flake update "${target}"
    fi
}

run_gc() { nix-store --gc; }

###

show_msg() {
    # shellcheck disable=SC2059
    printf "$(fmt_log_command "⇒ $1")\n" >&2
}

exit_err() {
    # shellcheck disable=SC2059
    printf "$(fmt_err "Error"): %s\n" "${1}" >&2
    exit 1
}

VERSION=0.1.0

show_version() { printf "%s\n" "${VERSION}"; }

RESET='\e[0m'

fmt_section() { echo -e "\e[1;36m${1}${RESET}"; }
fmt_name() { echo -e "\e[1;33m${1}${RESET}"; }
fmt_subcommand() { echo -e "\e[0;37m${1}${RESET}"; }
fmt_param() { echo -e "\e[0;35m${1}${RESET}"; }
fmt_err() { echo -e "\e[0;31m${1}${RESET}"; }
fmt_log_command() { echo -e "\e[1;33m${1}${RESET}"; }

parse_opts() {
    if [ "${#}" -eq 0 ]; then
        show_usage
        exit 0
    fi
    while [ "${#}" -gt 0 ]; do
        case "${1}" in
        rebuild | r)
            run_rebuild "${2}"
            exit 0
            ;;
        update | u)
            run_update "${2}"
            exit 0
            ;;
        gc)
            run_gc
            exit 0
            ;;
        -h | --help | h | help | "")
            show_usage
            exit 0
            ;;
        -v | --version)
            show_version
            exit 0
            ;;
        *)
            printf "Unknown option: %s\n" "${1}" >&2
            show_usage
            exit 1
            ;;
        esac
        # shellcheck disable=SC2137
        shift
    done
}

main() {
    parse_opts "${@}"
}

###

main "${@}"
