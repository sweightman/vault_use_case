# vault_use_case
To demonstrate the Vault use-case to ECS Digital

## Overview
HashiCorp’s Vault is a secret management tool allowing an organisation to safely store secrets (access keys, credentials, etc.). With Vault, application and users don’t have to store/remember secrets.
Vault has many features, including Encryption as a Service and Dynamic Secrets. 
This is the first part of the Vault Use-case, which will focus on Vault secrets, permissions and integration.

UseCase

Locally or on AWS, manually or automatically:

1. Set up Vault (in non-dev mode), using a config.hcl that you would have created beforehand. Use Consul as a storage backend.
2. Initialise the Vault and authenticate as root.
3. Understand how to read/write secrets
4. Mount the MySQL Secret Engine and find a way to generate readonly credentials for MYSQL (Hint: Dynamic Secret)
5. Create a policy that only allow to “generate readonly credentials for MYSQL” and assign it to a new token. Confirm this new token can’t do anything else.
6. Below is an incomplete python script, find ways to complete it : 
7. use EnvConsul to inject secrets into the script and read from getFromEnv()
8. write an API Call to get MySQL credentials from Vault.

```
code template:

import os, MySQLdb, requests, json

def getFromEnv():
    env_var = str(os.environ['ENV_VAR'])
    print "---FROM ENV---"
    print "Your Secret :", env_var
    print "\n"

def getFromAPI():
    # response = requests.get("http://localhost:8200" + " ..... ", headers = {"X-Vault-Token": YOUR_TOKEN})
    # 200 = OK, other = NOK
    if(response.ok):
      ....
    else:
      Resp.raise_for_status()

getFromEnv()```

## How to run
You need `make` and `docker` installed as a prerequisite. I have created seperate make tasks to align with the individual tasks in this use-case. Unfortunaetly, I made it to number 5 in the the list of 8 tasks.
Once you have checked out this repo to your local please run in the followng order ...
1. `make vault_env`
2. `make vault_init_login`
3. `make vault_understand_secrets`
4. `make vault_mysql_secret_engine`
5. `make vault_policy_token`
