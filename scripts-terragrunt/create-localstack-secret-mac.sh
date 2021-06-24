#!/usr/bin/env bash

export AWS_ACCESS_KEY_ID=mock_access_key
export AWS_SECRET_ACCESS_KEY=mock_secret_key
export AWS_DEFAULT_REGION=us-east-1

# Recreate secret at startup
#aws --endpoint-url=http://localstack.aws.prod.fabaleus.com:4566  secretsmanager delete-secret --secret-id /up/idp/local/containers/keycloak/config/{realm}/{client}-client-secret  --force-delete-without-recovery  >/dev/null
#aws --endpoint-url=http://localstack.aws.prod.fabaleus.com:4566  secretsmanager create-secret --name /up/idp/local/containers/keycloak/config/{realm}/{client}-client-secret --secret-string "secret"

# list all secrets
#aws  --endpoint-url=http://localstack.aws.prod.fabaleus.com:4566 secretsmanager  list-secrets | grep "Name"

PROJECT=${1}
SUBPROJECT=${2}
ENV=${3}
REALM=${4}
CLIENT_SECRET_NAME=${5}

CLIENT_SECRET=$( uuidgen  | tr "[:upper:]" "[:lower:]")
# example bash ./scripts/create-secret-mac.sh up idp fab fab-upg-sso fab-iam-debug-realm_client-secret

echo "Create secret for /${PROJECT}/${SUBPROJECT}/${ENV}/containers/keycloak/config/${REALM}/${CLIENT_SECRET_NAME}"
aws --endpoint-url=http://localstack.aws.prod.fabaleus.com:4566 secretsmanager create-secret --name /${PROJECT}/${SUBPROJECT}/${ENV}/containers/keycloak/config/${REALM}/${CLIENT_SECRET_NAME} --secret-string ${CLIENT_SECRET}
echo "Client secret was created and saved"
