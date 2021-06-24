#!/usr/bin/env bash

PROJECT=${1}
SUBPROJECT=${2}
ENV=${3}
KEYCLOAK_URL=${4}
KEYCLOAK_CLIENT_ID=${5}
KEYCLOAK_USER=${6}
KEYCLOAK_PASSWORD=${7}
REALM=${8}

cd ${ENV}/${REALM}/clients
source ../../../scripts-terragrunt/util.sh
echo "Executing 'terragrunt fmt' for $PWD"
terragrunt fmt

cd ../../..
cd ${ENV}/${REALM}/flows
echo "Executing 'terragrunt fmt' for $PWD"
terragrunt fmt

cd ../../..
cd ${ENV}/${REALM}/idps
echo "Executing 'terragrunt fmt' for $PWD"
terragrunt fmt

cd ../../..
cd ${ENV}/${REALM}/realm
echo "Executing 'terragrunt fmt' for $PWD"
terragrunt fmt

cd ../../..
cd ${ENV}/realms/${REALM}
echo "Executing 'terragrunt fmt' for $PWD"
terragrunt fmt

setAccessTokenLifespan 300 ${KEYCLOAK_URL} ${KEYCLOAK_USER} ${KEYCLOAK_PASSWORD}

echo "Start planning for env: ${ENV}/${REALM}"
../../../scripts-terragrunt/terragrunt-plan.sh ${PROJECT} ${SUBPROJECT} ${ENV} ${KEYCLOAK_URL} ${KEYCLOAK_CLIENT_ID} ${KEYCLOAK_USER} ${KEYCLOAK_PASSWORD} ${REALM}

while true; do
    read -p "Do you wish to apply these changes? (y or n): " yn
    case $yn in
        [Yy]* ) ../../../scripts-terragrunt/terragrunt-apply.sh ${ENV}; break;;
        [Nn]* ) break;;
        * ) echo "Please answer y or n.";;
    esac
done

setAccessTokenLifespan 60 ${KEYCLOAK_URL} ${KEYCLOAK_USER} ${KEYCLOAK_PASSWORD}

echo "Cleaning terragrunt leftovers"
rm -f ./"terragrunt-${ENV}.plan"

echo "Finished for env: ${ENV}"
