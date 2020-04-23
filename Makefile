clean:
	docker stop vault_use_case
	docker rm vault_use_case

build: clean
	docker build -t vault_use_case .

prep: build
	docker run -dt --cap-add=IPC_LOCK -v /sys/fs/cgroup:/sys/fs/cgroup:ro --name vault_use_case vault_use_case
	docker cp hashicorp.asc vault_use_case:/srv/hashicorp.asc
	docker cp ./consul vault_use_case:/srv/consul
	docker cp ./vault vault_use_case:/srv/vault

setup: prep
	docker exec -t vault_use_case /bin/bash -c "gpg --import /srv/hashicorp.asc"
	docker exec -t vault_use_case /bin/bash -c "/srv/consul/setup_consul.sh"
	docker exec -t vault_use_case /bin/bash -c "/srv/vault/setup_vault.sh"

vault_env: setup

vault_init_login:
	docker exec -t vault_use_case /bin/bash -c "/srv/vault/init_login_vault.sh"

vault_understand_secrets:
	docker exec -t vault_use_case /bin/bash -c "/srv/vault/understand_secrets.sh"

vault_mysql_secret_engine:
	docker exec -t vault_use_case /bin/bash -c "/srv/vault/mysql_secret_engine.sh"

vault_policy_token:
	docker exec -t vault_use_case /bin/bash -c "/srv/vault/policy_token.sh"
