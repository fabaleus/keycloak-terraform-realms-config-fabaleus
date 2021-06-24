resource "keycloak_oidc_identity_provider" "itsme_sandbox_idp" {
  realm                 = local.realm_id
  provider_id           = "itsme-oidc"
  alias                 = "itsme"
  authorization_url     = "https://e2emerchant.itsme.be/oidc/authorization"
  token_url             = "https://e2emerchant.itsme.be/oidc/token"
  user_info_url         = "https://e2emerchant.itsme.be/oidc/userinfo"
  jwks_url              = "https://e2emerchant.itsme.be/oidc/jwkSet"
  client_id             = "RbmBpct2Z1"
  client_secret         = "not relevant, but is a required field"
  ui_locales            = true
  backchannel_supported = false
  validate_signature    = true
  store_token           = false
  trust_email           = false
  default_scopes        = "openid service:UP_ALBATRS_LOGIN profile email phone"
  gui_order             = 1

  #first_broker_login_flow_alias = keycloak_authentication_flow.upg-first-broker-login.alias
  #post_broker_login_flow_alias  = keycloak_authentication_flow.upg-post-broker-login.alias

  extra_config = {
    privateKeyStoreLocation              = "/keystores/keystore-itsme.jks"
    awsKmsKeyArn                         = "arn:aws:kms:eu-west-1:154129775355:key/73166b2f-fe3f-4196-8adc-c2a915824e4d"
    privateKeyStorePassword              = "AQICAHigGxb3ltzOKgqcDFMW6Sexs6XykkWNQ7w+DF4b0TuyIAHXTOeccrH54Lcx3YQSlzlDAAAAYzBhBgkqhkiG9w0BBwagVDBSAgEAME0GCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMknCwtHg/2TyFjnsgAgEQgCB4UmNrxnryyaYryrD5DweM2VkEsAV7A42Q5ypHwNtKgA=="
    privateKeyEncryptAliasPassword       = "AQICAHigGxb3ltzOKgqcDFMW6Sexs6XykkWNQ7w+DF4b0TuyIAFoNEuDZI3ypgBiqCBQGC/1AAAAZDBiBgkqhkiG9w0BBwagVTBTAgEAME4GCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMKvp4UvXcJm8nDcXrAgEQgCFxJHaTwZbttD3auBBRxeFCAqNpcl/N+BtsPOhKEjV7Jpw="
    privateKeySignAliasPassword          = "AQICAHigGxb3ltzOKgqcDFMW6Sexs6XykkWNQ7w+DF4b0TuyIAFoNEuDZI3ypgBiqCBQGC/1AAAAZDBiBgkqhkiG9w0BBwagVTBTAgEAME4GCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMKvp4UvXcJm8nDcXrAgEQgCFxJHaTwZbttD3auBBRxeFCAqNpcl/N+BtsPOhKEjV7Jpw="
    privateKeySignAlias                  = "sign"
    privateKeyEncryptAlias               = "enc"
    audience                             = "https://e2emerchant.itsme.be/oidc/token"
    issuer                               = "https://e2emerchant.itsme.be/oidc"
    use_request_uri                      = true
    claim_city_of_birth                  = false
    claim_device                         = false
    claim_eid                            = false
    claim_nationality                    = false
    claim_photo                          = false
    forwardScopeParameterValues          = true
    forwardScopeParameterValuesBaseScope = "openid service:UP_ALBATRS_LOGIN"
    forwardScopeParameterValuesPrefix    = "itsme"
  }
}

resource "keycloak_identity_provider_token_exchange_scope_permission" "itsme_sandbox_idp-client_token_exchange-idp-permission" {
  realm_id       = local.realm_id
  provider_alias = keycloak_oidc_identity_provider.itsme_sandbox_idp.alias
  policy_type    = "client"
  clients = [
    "${var.fab_iam_debug_client_id}",
  ]
}

resource "keycloak_hardcoded_attribute_identity_provider_mapper" "itsme_sandbox_idp-hardcoded_idp_alias_to_session-mapper" {
  realm                   = local.realm_id
  name                    = "up:sso:sess:idp"
  attribute_name          = "up:sso:sess:idp"
  identity_provider_alias = keycloak_oidc_identity_provider.itsme_sandbox_idp.alias
  attribute_value         = keycloak_oidc_identity_provider.itsme_sandbox_idp.alias
  user_session            = true
  extra_config = {
    syncMode = "FORCE"
  }
}
