#!/usr/bin/env bash

set -o errexit
set -o pipefail
#set -o verbose
#set -o xtrace

source ~/.bashrc

yum install https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm -y
yum install mysql-community-server -y
systemctl enable mysqld
systemctl start mysqld
systemctl status mysqld

MYSQL_TEMP_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $(NF)}')
mysql --connect-expired-password -uroot -p${MYSQL_TEMP_PASSWORD} < /srv/vault/mysql_user.sql

vault secrets enable mysql

vault write mysql/config/connection connection_url="root:Vault@23042020@tcp(localhost:3306)/"

vault write mysql/config/lease lease=1h lease_max=24h

vault write mysql/roles/readonly sql="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT SELECT ON *.* TO '{{name}}'@'%';"

vault read mysql/creds/readonly
