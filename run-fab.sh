#!/usr/bin/env bash

REALM=${1}
REALM_PART=${2}
PROJECT="up"
SUBPROJECT="idp"
ENV="fab"
KEYCLOAK_URL="https://keycloak.iam.prod.fabaleus.com"
KEYCLOAK_USER="admin"
KEYCLOAK_PASSWORD="@^33W&ZedUy%Ue"
KEYCLOAK_CLIENT_ID="admin-cli"
AWS_REGION=eu-west-1
#export TF_LOG=INFO
#export TF_LOG_PATH=./terraform.log


./scripts-terragrunt/run.sh ${PROJECT} ${SUBPROJECT} ${ENV} ${KEYCLOAK_URL} ${KEYCLOAK_CLIENT_ID} ${KEYCLOAK_USER} ${KEYCLOAK_PASSWORD} ${REALM} ${REALM_PART}
