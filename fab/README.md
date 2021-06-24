# read me local env

This folder can have local .tf files to test certain set-ups on a local env.
all .tf files (except for the main.tf) are ignored. (they are a part of the .gitignore file)

It is up to the developer to start a local keycloak docker container.
This local env assumes the container is reachable with following params:

```
PROJECT="up"
SUBPROJECT="idp"
ENV="local"
KEYCLOAK_URL="http://localhost:8080"
KEYCLOAK_USER="admin"
KEYCLOAK_PASSWORD="admin"
KEYCLOAK_CLIENT_ID="admin-cli"
```


The local env can be tested by running `./run-local.sh` from the root folder.


# Use docker-compose to spawn up you local env.

```
cd local
docker-compose up
```
See docker-compose/localstack/init.sh for secretsmanager commands.

# Recreate secret at startup
#aws --endpoint-url=http://localhost:4566  secretsmanager delete-secret --secret-id /up/idp/local/containers/keycloak/config/{realm}/{client}-client-secret  --force-delete-without-recovery  >/dev/null
#aws --endpoint-url=http://localhost:4566  secretsmanager create-secret --name /up/idp/local/containers/keycloak/config/{realm}/{client}-client-secret --secret-string "secret"

# list all secrets
#aws  --endpoint-url=http://localhost:4566 secretsmanager  list-secrets | grep "Name"

aws --endpoint-url=http://localstack.aws.prod.fabaleus.com:4566  secretsmanager create-secret --name /up/idp/fab/containers/keycloak/config/smtp-server-auth-password --secret-string "secret"
aws --endpoint-url=http://localstack.aws.prod.fabaleus.com:4566  secretsmanager create-secret --name /up/idp/fab/containers/keycloak/config/fab-upg-sso/registration-data-secret --secret-string "secret"
aws --endpoint-url=http://localstack.aws.prod.fabaleus.com:4566  secretsmanager create-secret --name /up/idp/fab/containers/keycloak/config/fab-upg-sso/google_idp-client-secret --secret-string "secret"
aws --endpoint-url=http://localstack.aws.prod.fabaleus.com:4566  secretsmanager create-secret --name /up/idp/fab/containers/keycloak/config/fab-upg-sso/e-herkenning_idp-client_secret --secret-string "secret"
aws --endpoint-url=http://localstack.aws.prod.fabaleus.com:4566  secretsmanager create-secret --name /up/idp/fab/containers/keycloak/config/fab-upg-sso/comptexpert_idp-api-key --secret-string "secret"
aws --endpoint-url=http://localstack.aws.prod.fabaleus.com:4566  secretsmanager create-secret --name /up/idp/fab/containers/keycloak/config/fab-upg-sso/azure-ad-kbs-idp-client-secret --secret-string "secret"
aws --endpoint-url=http://localstack.aws.prod.fabaleus.com:4566  secretsmanager create-secret --name /up/idp/fab/containers/keycloak/config/fab-upg-sso/community-api-vas-basic-auth-pass --secret-string "secret"
aws --endpoint-url=http://localstack.aws.prod.fabaleus.com:4566  secretsmanager create-secret --name /up/idp/fab/containers/keycloak/config/fab-upg-sso/pentest-client-secret --secret-string "secret"
aws --endpoint-url=http://localstack.aws.prod.fabaleus.com:4566  secretsmanager create-secret --name /up/idp/fab/containers/keycloak/config/fab-upg-sso/iam-baltics_idp-client_secret --secret-string "secret"
aws --endpoint-url=http://localstack.aws.prod.fabaleus.com:4566  secretsmanager create-secret --name /up/idp/fab/containers/keycloak/config/fab-upg-sso/franceconnect_idp-client-secret --secret-string "secret"
aws --endpoint-url=http://localstack.aws.prod.fabaleus.com:4566  secretsmanager create-secret --name /up/idp/fab/containers/keycloak/config/fab-upg-sso/azure-ad-liantis-idp-client-secret --secret-string "secret"
aws --endpoint-url=http://localstack.aws.prod.fabaleus.com:4566  secretsmanager create-secret --name /up/idp/fab/containers/keycloak/config/fab-upg-sso/upg-user-api-provider/rest-api-basic-auth-pas --secret-string "secret"
aws --endpoint-url=http://localstack.aws.prod.fabaleus.com:4566  secretsmanager create-secret --name /up/idp/fab/containers/keycloak/config/fab-upg-sso/upg-user-api-provider/community-api-basic-auth-pass --secret-string "secret"
aws --endpoint-url=http://localstack.aws.prod.fabaleus.com:4566  secretsmanager create-secret --name /up/idp/fab/containers/keycloak/config/fab-upg-sso/upg-user-api-provider/users-api-token --secret-string "secret"

aws --endpoint-url=http://localstack.aws.prod.fabaleus.com:4566  secretsmanager create-secret --name /up/idp/fab/containers/keycloak/config/fab-upg-sso/upg-user-api-provider/community-api-vas-basic-auth-pass --secret-string "secret"


aws --endpoint-url=http://localstack.aws.prod.fabaleus.com:4566  secretsmanager create-secret --name /up/idp/fab/containers/keycloak/config/fab-upg-sso/upg-user-api-provider/rest-api-basic-auth-pass --secret-string "secret"
