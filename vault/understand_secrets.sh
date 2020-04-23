#!/usr/bin/env bash

set -o errexit
set -o pipefail
#set -o verbose
#set -o xtrace

source ~/.bashrc

vault secrets list
vault secrets enable -path=secret kv
vault secrets list

vault kv put secret/some_app admin=fsdfsfdsfsdf developer=asdadsadada tester=vbnvnbvnvn

vault kv list secret
vault kv get secret/some_app

