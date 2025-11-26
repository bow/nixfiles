#!/usr/bin/env bash

set -eo pipefail

REPO_DIR="$(dirname "$(readlink -f "$0")")"

show_usage() {
    cat <<__USAGE__
$(fmt_section "SYNOPSIS")
    $(fmt_name "$(basename "${0}")") $(fmt_subcommand "[build-iso|build-machine|fmt|rebuild|update|gc]")

    Helper script for common Nix tasks.

$(fmt_section "OPTIONS")
    $(fmt_subcommand "build-iso|bi")                \`nix build .#nixosConfigurations.iso.config.system.build.isoImage\`
    $(fmt_subcommand "build-machine|bm") $(fmt_param "machine")    \`nix build .#nixosConfigurations.$(fmt_param "machine").config.system.build.toplevel\`
    $(fmt_subcommand "fmt|f")                       \`nixfmt -- **/*.nix\`
    $(fmt_subcommand "rebuild|r") $(fmt_param "machine")           \`nixos-rebuild --flake #.$(fmt_param "machine")\`
    $(fmt_subcommand "update|u") $(fmt_param "target")             \`nix flake update $(fmt_param "target")\`
    $(fmt_subcommand "gc")                          \`nix-store --gc\`
__USAGE__
}

run_rebuild() {
    machine=${1:-${HOSTNAME}}

    show_msg "Starting rebuild for machine=${machine}"
    sudo nixos-rebuild --flake "${REPO_DIR}"\#"${machine}" --fast switch
}

run_build_iso() {
    show_msg "Starting ISO installer build"
    nix build .#nixosConfigurations.iso.config.system.build.isoImage
}

run_build_machine() {
    machine=${1}
    test -n "${machine}" || exit_err "machine not specified"

    show_msg "Starting build-machine for machine=${machine}"
    nix build ".#nixosConfigurations.${machine}.config.system.build.toplevel"
}

run_fmt() {
    show_msg "Formatting all .nix files"
    find . -name "*.nix" -not -path "./result/*" -not -path "./sandbox/*" -exec nixfmt {} \;
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
        build-iso | bi)
            run_build_iso
            exit 0
            ;;
        build-machine | bm)
            run_build_machine "${2}"
            exit 0
            ;;
        fmt | f)
            run_fmt
            exit 0
            ;;
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
