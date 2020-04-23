#!/usr/bin/env bash

set -o errexit
set -o pipefail
#set -o verbose
#set -o xtrace

VAULT_URL="https://releases.hashicorp.com/vault"
VAULT_VERSION="1.4.0"

curl --silent --remote-name "${VAULT_URL}/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip"
curl --silent --remote-name "${VAULT_URL}/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS"
curl --silent --remote-name "${VAULT_URL}/${VAULT_VERSION}/vault_${VAULT_VERSION}_SHA256SUMS.sig"

gpg --verify "vault_${VAULT_VERSION}_SHA256SUMS.sig" "vault_${VAULT_VERSION}_SHA256SUMS"

grep linux_amd64 "vault_${VAULT_VERSION}_SHA256SUMS" > "vault_${VAULT_VERSION}_linux_amd64_SHA256SUM"
sha256sum -c "vault_${VAULT_VERSION}_linux_amd64_SHA256SUM"

unzip "vault_${VAULT_VERSION}_linux_amd64.zip" -d /usr/local/bin
vault --version

vault -autocomplete-install
complete -C /usr/local/bin/vault vault

setcap cap_ipc_lock=+ep /usr/local/bin/vault

useradd --system --create-home --home /etc/vault.d --shell /bin/false vault

cp /srv/vault/config.hcl /etc/vault.d/

cp /srv/vault/vault.service /etc/systemd/system/vault.service
systemctl enable vault
systemctl start vault
systemctl status vault

echo "export VAULT_ADDR=http://127.0.0.1:8200" >> ~/.bashrc
source ~/.bashrc

sleep 5
vault status || true
