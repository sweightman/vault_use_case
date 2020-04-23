#!/usr/bin/env bash

set -o errexit
set -o pipefail
#set -o verbose
#set -o xtrace

source ~/.bashrc
echo "vault operator init -key-shares=3 -key-threshold=3 -format=\"json\" > .init_output.json"
vault operator init -key-shares=3 -key-threshold=3 -format="json" > .init_output.json
echo "vault status"
vault status || true

COUNT_UNSEAL_KEYS=$(jq '.unseal_keys_b64 | length' .init_output.json)
for ((i = 0; i < ${COUNT_UNSEAL_KEYS}; i++)); do
  UNSEAL_KEY=$(jq -r --argjson i "$i" '.unseal_keys_b64[$i]' .init_output.json)
  echo "vault operator unseal ${UNSEAL_KEY}"
  vault operator unseal ${UNSEAL_KEY}
done

ROOT_TOKEN=$(jq -r '.root_token' .init_output.json)
echo ${ROOT_TOKEN} > /etc/vault.d/.root_token
chmod 600 /etc/vault.d/.root_token
vault login ${ROOT_TOKEN}

