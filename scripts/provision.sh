#!/usr/bin/env bash

set -ueo pipefail

SCRIPT_DIR="$(dirname "$0")"

MACHINE=${1}
IP_ADDR=${2}
SSH_USER=${3:-root}

MACHINE_FILES="${SCRIPT_DIR}/../machines/${MACHINE}/files"
LOCAL_MACHINE_KEY="${MACHINE_FILES}/persist/machine-key.txt"
PASS_SECRET_PATH="machines/${MACHINE}/luks"

mkdir -p "$(dirname "${LOCAL_MACHINE_KEY}")"

(
    test -f "${LOCAL_MACHINE_KEY}" ||
        age-keygen -o "${LOCAL_MACHINE_KEY}"
) && (
    grep '# public key: ' "${LOCAL_MACHINE_KEY}" |
        sed 's/# public key: //'
)

nix run github:nix-community/nixos-anywhere -- \
    --flake ".#${MACHINE}" \
    --target-machine "${SSH_USER}@${IP_ADDR}" \
    --generate-hardware-config nixos-generate-config "./machines/${MACHINE}/hardware.nix" \
    --disk-encryption-keys /tmp/disk.key <(pass "${PASS_SECRET_PATH}") \
    --extra-files "${MACHINE_FILES}"
