#!/usr/bin/env bash

PROJECT="up"
SUBPROJECT="idp"
ENV=${1}
KEYCLOAK_URL=${2}
KEYCLOAK_CLIENT_ID="admin-cli"
KEYCLOAK_USER=${3}
KEYCLOAK_PASSWORD=$(aws secretsmanager get-secret-value --secret-id /${PROJECT}/${SUBPROJECT}/${ENV}/containers/keycloak/keycloak_password | jq .SecretString | tr -d '["]')

echo "Start import master realm for env: ${ENV}"
echo "Copying terragrunt keycloak provider plugin"

cp -R ../terraform-keycloak-provider-plugin/. .terraform

echo ""
echo "terragrunt Init"
echo "========================="

terragrunt init

echo ""
echo "terragrunt import"
echo "========================="

terragrunt import \
    -var="project=${PROJECT}" \
    -var="subproject=${SUBPROJECT}" \
    -var="env=${ENV}" \
    -var="keycloak_url=${KEYCLOAK_URL}" \
    -var="keycloak_client_id=${KEYCLOAK_CLIENT_ID}" \
    -var="keycloak_user=${KEYCLOAK_USER}" \
    -var="keycloak_password=${KEYCLOAK_PASSWORD}" \
    keycloak_realm.master master

# Other import examples
#  terraform import \
#     -var="project=${PROJECT}" \
#     -var="subproject=${SUBPROJECT}" \
#     -var="env=${ENV}" \
#     -var="keycloak_url=${KEYCLOAK_URL}" \
#     -var="keycloak_client_id=${KEYCLOAK_CLIENT_ID}" \
#     -var="keycloak_user=${KEYCLOAK_USER}" \
#     -var="keycloak_password=${KEYCLOAK_PASSWORD}" \
#     keycloak_realm.classic-myup-dev-consumer classic-myup-dev-consumer-tf

#  terraform import \
#     -var="project=${PROJECT}" \
#     -var="subproject=${SUBPROJECT}" \
#     -var="env=${ENV}" \
#     -var="keycloak_url=${KEYCLOAK_URL}" \
#     -var="keycloak_client_id=${KEYCLOAK_CLIENT_ID}" \
#     -var="keycloak_user=${KEYCLOAK_USER}" \
#     -var="keycloak_password=${KEYCLOAK_PASSWORD}" \
#     keycloak_oidc_google_identity_provider.master_google master/google

echo ""
echo "========================="
echo "Finished importing master for env: ${ENV}"
echo ""
