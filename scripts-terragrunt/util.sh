#!/usr/bin/env bash

uriencode() {
  s="${1//'%'/%25}"
  s="${s//' '/%20}"
  s="${s//'"'/%22}"
  s="${s//'#'/%23}"
  s="${s//'$'/%24}"
  s="${s//'&'/%26}"
  s="${s//'+'/%2B}"
  s="${s//','/%2C}"
  s="${s//'/'/%2F}"
  s="${s//':'/%3A}"
  s="${s//';'/%3B}"
  s="${s//'='/%3D}"
  s="${s//'?'/%3F}"
  s="${s//'@'/%40}"
  s="${s//'['/%5B}"
  s="${s//']'/%5D}"
  printf %s "$s"
}

function setAccessTokenLifespan(){ #accessTokenLifespan, keycloak_url, keycloak_user, keycloak_password
    accessTokenLifespan=${1}
    keycloak_url=${2}
    keycloak_user=${3}
    keycloak_password=$(uriencode ${4})

    accessToken=$(
        curl -s --fail \
            -d "username=${keycloak_user}" \
            -d "password=${keycloak_password}" \
            -d "client_id=admin-cli" \
            -d "grant_type=password" \
            "${keycloak_url}/auth/realms/master/protocol/openid-connect/token" \
            | jq -r '.access_token'
    )

    masterRealmExtendAccessToken=$(jq -n "{
        accessTokenLifespan: ${accessTokenLifespan},
    }")

    echo "Setting access token lifespan to ${accessTokenLifespan} seconds on ${keycloak_url}/auth/admin/realms/master"

    curl --fail \
        -X PUT \
        -H "Authorization: bearer ${accessToken}" \
        -H "Content-Type: application/json" \
        -d "${masterRealmExtendAccessToken}" \
        "${keycloak_url}/auth/admin/realms/master"
}