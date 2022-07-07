# Vault Plugin for Neo4j Secrets Engine
### Build the plugin
```
make
```
The printed sha256sum will be required when registering the plugin later.


### Run locally

1) Start a local neo4j container with root username `neo4j` and password `secret`
```bash
docker run --rm -it -p7474:7474 \
            -p7687:7687 \
            --env=NEO4J_ACCEPT_LICENSE_AGREEMENT=yes \
            --env=NEO4J_AUTH=neo4j/secret \
            neo4j:enterprise
```

2) Start a local vault server:
```bash

export VAULT_ADDR=http://localhost:8200

vault server -dev -dev-plugin-dir=/path/to/plugin/build/folder/bin
```

3) Register and configure the plugin:
```bash
export VAULT_ADDR=http://localhost:8200

vault plugin register -sha256 f1d33bb86f9b775cc1146b73888111aa20a893cc185cccc49ad1bdc6b5309deb database neo4j-database-plugin

vault secrets enable database

vault write database/config/my-neo4j-database \
       plugin_name=neo4j-database-plugin \
       allowed_roles="test" \
       connection_url="neo4j://localhost:7687/" \
       username=neo4j \
       password=secret

# These creation statements don't actually grant any permissions/roles
vault write database/roles/test \
    db_name=my-neo4j-database \
    creation_statements='CREATE OR REPLACE USER $username SET PLAINTEXT PASSWORD $password' \
    creation_statements='CREATE (n:NEO4J_USER {username: $username})' \
    default_ttl="1m" \
    max_ttl="1h"

vault read -format=json database/creds/test
```
