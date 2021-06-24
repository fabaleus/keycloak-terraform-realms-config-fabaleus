resource "keycloak_oidc_identity_provider" "franceconnect_idp" {
  realm                 = local.realm_id
  provider_id           = "franceconnect"
  alias                 = "franceconnect"
  display_name          = "FranceConnect Intégration"
  authorization_url     = "https://fcp.integ01.dev-franceconnect.fr/api/v1/authorize?acr_values=eidas1"
  token_url             = "https://fcp.integ01.dev-franceconnect.fr/api/v1/token"
  user_info_url         = "https://fcp.integ01.dev-franceconnect.fr/api/v1/userinfo"
  logout_url            = "https://fcp.integ01.dev-franceconnect.fr/api/v1/logout"
  client_id             = "e8600114396ea808a2ddbc6e9c34c261b8645fb358942cf0ef896b69e7d95a8d"
  client_secret         = module.fab-upg-sso-franceconnect-idp-client_secret.secret_value
  ui_locales            = false
  backchannel_supported = false
  validate_signature    = true
  store_token           = false
  trust_email           = true
  default_scopes        = "openid profile email identite_pivot"
  sync_mode             = "FORCE"

  #first_broker_login_flow_alias = keycloak_authentication_flow.upg-first-broker-login.alias
  #post_broker_login_flow_alias  = keycloak_authentication_flow.upg-post-broker-login.alias

  extra_config = {
    clientAuthMethod = "client_secret_post"
  }
}

module "fab-upg-sso-franceconnect-idp-client_secret" {
  source      = "../../../modules/aws_secretsmanager_secret_value"
  secret_path = "/${var.project}/${var.subproject}/${var.env}/containers/keycloak/config/${local.realm_id}/franceconnect_idp-client-secret"
}

resource "keycloak_identity_provider_token_exchange_scope_permission" "franceconnect_idp-client_token_exchange-idp-permission" {
  realm_id       = local.realm_id
  provider_alias = keycloak_oidc_identity_provider.franceconnect_idp.alias
  policy_type    = "client"
  clients = [
    "${var.fab_iam_debug_client_id}",
  ]
}

resource "keycloak_hardcoded_attribute_identity_provider_mapper" "franceconnect_idp-hardcoded_idp_alias_to_session-mapper" {
  realm                   = local.realm_id
  name                    = "up:sso:sess:idp"
  attribute_name          = "up:sso:sess:idp"
  identity_provider_alias = keycloak_oidc_identity_provider.franceconnect_idp.alias
  attribute_value         = keycloak_oidc_identity_provider.franceconnect_idp.alias
  user_session            = true
  extra_config = {
    syncMode = "FORCE"
  }
}
