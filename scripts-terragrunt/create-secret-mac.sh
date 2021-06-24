#!/usr/bin/env bash

PROJECT=${1}
SUBPROJECT=${2}
ENV=${3}
REALM=${4}
CLIENT_SECRET_NAME=${5}

CLIENT_SECRET=$( uuidgen  | tr "[:upper:]" "[:lower:]")
# example aws-vault exec iam-uat -- ./scripts/create-secret-mac.sh up idp uat pp-paa-platformsandapps community-banqupvn_client-secret

echo "Create secret for /${PROJECT}/${SUBPROJECT}/${ENV}/containers/keycloak/config/${REALM}/${CLIENT_SECRET_NAME}"
aws secretsmanager create-secret --name /${PROJECT}/${SUBPROJECT}/${ENV}/containers/keycloak/config/${REALM}/${CLIENT_SECRET_NAME} --secret-string ${CLIENT_SECRET}
echo "Client secret was created and saved"
