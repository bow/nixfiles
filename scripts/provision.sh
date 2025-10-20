#!/usr/bin/env bash

set -ueo pipefail

HOST=${1}
IP_ADDR=${2}
SSH_USER=${3:-root}

SCRIPT_DIR="$(dirname "$0")"

HOST_FILES="${SCRIPT_DIR}/../hosts/${HOST}/files"
LOCAL_HOST_KEY="${HOST_FILES}/persist/machine-key.txt"
PASS_SECRET_PATH="hosts/${HOST}/luks"

mkdir -p "$(dirname "${LOCAL_HOST_KEY}")"

(
    test -f "${LOCAL_HOST_KEY}" ||
        age-keygen -o "${LOCAL_HOST_KEY}"
) && (
    grep '# public key: ' "${LOCAL_HOST_KEY}" |
        sed 's/# public key: //'
)

nix run github:nix-community/nixos-anywhere -- \
    --flake ".#${HOST}" \
    --target-host "${SSH_USER}@${IP_ADDR}" \
    --generate-hardware-config nixos-generate-config "./hosts/${HOST}/hardware.nix" \
    --disk-encryption-keys /tmp/disk.key <(pass "${PASS_SECRET_PATH}") \
    --extra-files "${HOST_FILES}"
