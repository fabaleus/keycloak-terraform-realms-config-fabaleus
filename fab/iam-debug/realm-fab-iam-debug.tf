resource "keycloak_realm" "fab-iam-debug" {
  realm                = "fab-iam-debug"
  display_name         = "INVISO Pentest Pre Production"
  enabled              = true
  registration_allowed = true

  login_theme   = "up-keycloak"
  account_theme = "up-keycloak"
  admin_theme   = "up-keycloak"
  email_theme   = "up-keycloak"

  #browser_flow      = "debug-browser-flow"
  #registration_flow = "debug-registration-flow"

  security_defenses {
    headers {
      content_security_policy = "frame-src 'self'; frame-ancestors 'self'; object-src 'none'; script-src 'self' 'unsafe-inline';"
    }
    brute_force_detection {
      permanent_lockout                = false
      max_login_failures               = 30
      wait_increment_seconds           = 60
      quick_login_check_milli_seconds  = 1000
      minimum_quick_login_wait_seconds = 60
      max_failure_wait_seconds         = 900
      failure_reset_time_seconds       = 43200
    }
  }

  sso_session_idle_timeout = "1h"
  access_token_lifespan    = "30m"
  revoke_refresh_token     = true
  refresh_token_max_reuse  = 0
  ssl_required             = "external"

  attributes = {
    smsGatewayEnable           = false
    otpAllowedRecoveryChannels = "email"
    pinCodeMaxTime             = 10
    pinCodeMaxUnit             = "Minutes"
    frontendUrl                = "https://keycloak.iam.prod.fabaleus.com/auth/"

    idpForUpProductsFallback = false

    upUsersCreateInParentRealmIdpAlias = "upg-sso"
    upUsersCreateInParentRealmName     = "fab-upg-sso"
    //upUsersCreateInParentRealmName     = keycloak_realm.fab-upg-sso.realm


  }
}
