resource "keycloak_oidc_google_identity_provider" "google_idp" {
  realm       = local.realm_id
  store_token = false
  trust_email = true
  enabled     = true

  client_id     = "810552663427-e1mlle7ir8te9qllo8hl5r4bmj2tsd69.apps.googleusercontent.com"
  client_secret = module.fab-upg-sso-google-idp-client_secret.secret_value

  #first_broker_login_flow_alias = keycloak_authentication_flow.upg-first-broker-login.alias
  #post_broker_login_flow_alias  = keycloak_authentication_flow.upg-post-broker-login.alias
}

module "fab-upg-sso-google-idp-client_secret" {
  source      = "../../../modules/aws_secretsmanager_secret_value"
  secret_path = "/${var.project}/${var.subproject}/${var.env}/containers/keycloak/config/${local.realm_id}/google_idp-client-secret"
}

resource "keycloak_hardcoded_attribute_identity_provider_mapper" "google_idp-hardcoded_idp_alias_to_session-mapper" {
  realm                   = local.realm_id
  name                    = "up:sso:sess:idp"
  attribute_name          = "up:sso:sess:idp"
  identity_provider_alias = "google"
  attribute_value         = "google"
  user_session            = true
  extra_config = {
    syncMode = "FORCE"
  }
}
