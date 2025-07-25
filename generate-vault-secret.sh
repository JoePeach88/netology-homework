#!/bin/bash
set -euo pipefail

prompt_if_empty() {
    local val="$1"
    local prompt_msg="$2"
    if [[ -z "$val" ]]; then
        read -rp "$prompt_msg: " val
    fi
    echo "$val"
}

group=$(prompt_if_empty "${1:-}" "Enter group")
key=$(prompt_if_empty "${2:-}" "Enter key")
value=$(prompt_if_empty "${3:-}" "Enter value")

mkdir -p "deployment/ansible/inventories/group_vars/${group}"

encrypted_secret=$(ansible-vault encrypt_string --vault-password-file deployment/ansible/vault-password.password "$value" --name "$key")

echo "$encrypted_secret" >> "deployment/ansible/inventories/group_vars/${group}/vars.yml"
