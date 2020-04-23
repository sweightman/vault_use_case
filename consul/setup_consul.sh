#!/usr/bin/env bash

set -o errexit
set -o pipefail
#set -o verbose
#set -o xtrace

CONSUL_URL="https://releases.hashicorp.com/consul"
CONSUL_VERSION="1.7.2"

curl --silent --remote-name "${CONSUL_URL}/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip"
curl --silent --remote-name "${CONSUL_URL}/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_SHA256SUMS"
curl --silent --remote-name "${CONSUL_URL}/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_SHA256SUMS.sig"

gpg --verify "consul_${CONSUL_VERSION}_SHA256SUMS.sig" "consul_${CONSUL_VERSION}_SHA256SUMS"

grep linux_amd64 "consul_${CONSUL_VERSION}_SHA256SUMS" > "consul_${CONSUL_VERSION}_linux_amd64_SHA256SUM"
sha256sum -c "consul_${CONSUL_VERSION}_linux_amd64_SHA256SUM"

unzip "consul_${CONSUL_VERSION}_linux_amd64.zip" -d /usr/local/bin
consul --version

consul -autocomplete-install
complete -C /usr/local/bin/consul consul

useradd --system --create-home --home /etc/consul.d --shell /bin/false consul

mkdir -p /opt/consul
chown -R consul:consul /opt/consul

cp /srv/consul/*.hcl /etc/consul.d/

cp /srv/consul/consul.service /etc/systemd/system/consul.service
systemctl enable consul
systemctl start consul
systemctl status consul
