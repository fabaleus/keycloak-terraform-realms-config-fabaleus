#!/usr/bin/env bash

PROJECT=${1}
SUBPROJECT=${2}
ENV=${3}
KEYCLOAK_URL=${4}
KEYCLOAK_CLIENT_ID=${5}
KEYCLOAK_USER=${6}
KEYCLOAK_PASSWORD=${7}
REALM=${8}

echo "terragrunt-plan.sh: $PWD"
echo "========================="
echo ""
echo "terraform init realm"
echo "========================="
terraform -chdir=../../${REALM}/realm init

echo ""
echo "terraform init clients"
echo "========================="
terraform -chdir=../../${REALM}/clients init

echo ""
echo "terraform init flows"
echo "========================="
terraform -chdir=../../${REALM}/flows init

echo ""
echo "terraform init idps"
echo "========================="
terraform -chdir=../../${REALM}/idps init

echo ""
echo "terraform init placeholder"
echo "========================="
terraform init

echo ""
echo "terragrunt run-all Plan"
echo "========================="

terragrunt run-all plan --out="terragrunt-${ENV}.plan" \
    -var="project=${PROJECT}" \
    -var="subproject=${SUBPROJECT}" \
    -var="env=${ENV}" \
    -var="keycloak_url=${KEYCLOAK_URL}" \
    -var="keycloak_client_id=${KEYCLOAK_CLIENT_ID}" \
    -var="keycloak_user=${KEYCLOAK_USER}" \
    -var="keycloak_password=${KEYCLOAK_PASSWORD}"

echo ""
echo "========================="
echo "Finished planning for env: ${ENV}"
echo ""
