#!/usr/bin/env bash

PROJECT=${1}
SUBPROJECT=${2}
ENV=${3}
REALM=${4}
CLIENT_SECRET_NAME=${5}

randpw(){ < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;}

CLIENT_SECRET=$(randpw)
#CLIENT_SECRET=$( uuidgen  | tr "[:upper:]" "[:lower:]")

echo "Create secret for /${PROJECT}/${SUBPROJECT}/${ENV}/containers/keycloak/config/${REALM}/${CLIENT_SECRET_NAME}"
aws secretsmanager create-secret --name /${PROJECT}/${SUBPROJECT}/${ENV}/containers/keycloak/config/${REALM}/${CLIENT_SECRET_NAME} --secret-string ${CLIENT_SECRET}
echo "Client secret was created and saved"