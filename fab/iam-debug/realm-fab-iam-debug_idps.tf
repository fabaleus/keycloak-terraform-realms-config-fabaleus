resource "keycloak_oidc_identity_provider" "fab-iam-debug-upg-sso_idp" {
  realm              = keycloak_realm.fab-iam-debug.id
  alias              = "upg-sso"
  provider_id        = "up-oidc"
  authorization_url  = "https://keycloak.iam.prod.fabaleus.com/auth/realms/${var.upg_sso_realm_id}/protocol/openid-connect/auth"
  token_url          = "https://keycloak.iam.prod.fabaleus.com/auth/realms/${var.upg_sso_realm_id}/protocol/openid-connect/token"
  user_info_url      = "https://keycloak.iam.prod.fabaleus.com/auth/realms/${var.upg_sso_realm_id}/protocol/openid-connect/userinfo"
  jwks_url           = "https://keycloak.iam.prod.fabaleus.com/auth/realms/${var.upg_sso_realm_id}/protocol/openid-connect/certs"
  logout_url         = "https://keycloak.iam.prod.fabaleus.com/auth/realms/${var.upg_sso_realm_id}/protocol/openid-connect/logout"
  validate_signature = true
  client_id          = var.upg_sso_realm_client_id
  client_secret      = "fdsfdsfdsfsdhhfjgdshfghjdsagfhjgsdahfghdsja"
  default_scopes     = "openid"
  trust_email        = true
  ui_locales         = true
  store_token        = false
  sync_mode          = "FORCE"

  first_broker_login_flow_alias = keycloak_authentication_flow.fab-iam-debug_upg-first-broker-login.alias

  extra_config = {
    clientAuthMethod               = "client_secret_post"
    upAutoMapUserInfo              = true
    upUseLogger                    = false
    registrationUrl                = "https://keycloak.iam.prod.fabaleus.com/auth/realms/${var.upg_sso_realm_id}/protocol/openid-connect/registrations"
    forwardParameters              = "up-custom-data"
    upForwardSessionNoteName       = "up-product,registration-data,up-product-display"
    upForwardSessionNoteQueryParam = "up-product,up_registration_data,up-product-display"
  }
}
