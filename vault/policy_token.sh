#!/usr/bin/env bash

set -o errexit
set -o pipefail
#set -o verbose
#set -o xtrace

source ~/.bashrc

export VAULT_TOKEN=$(< /etc/vault.d/.root_token)

cat <<EOF > /etc/vault.d/readonly_policy.hcl
path "mysql/*" {
  capabilities = ["read"]
}
EOF

echo "vault policy write readonly_policy /etc/vault.d/readonly_policy.hcl"
vault policy write readonly_policy /etc/vault.d/readonly_policy.hcl

echo "vault token create -policy=readonly_policy -format=json > .token_creation.json"
vault token create -policy=readonly_policy -format=json > .token_creation.json

VAULT_TOKEN=$(jq -r '.auth.client_token' .token_creation.json)

echo "vault read mysql/creds/readonly"
vault read mysql/creds/readonly

echo "vault write mysql/config/lease lease=1h lease_max=24h || true"
vault write mysql/config/lease lease=1h lease_max=24h || true
