resource "keycloak_realm" "fab-upg-sso" {
  realm                          = "fab-upg-sso"
  display_name                   = "Fabaleus sso parent realm aanpassing"
  enabled                        = true
  registration_allowed           = true
  registration_email_as_username = true
  reset_password_allowed         = true
  verify_email                   = false
  login_with_email_allowed       = true
  remember_me                    = true

  login_theme   = "upg-default-1203.0.0"
  account_theme = "up-keycloak"
  admin_theme   = "up-keycloak"
  email_theme   = "up-keycloak"

  internationalization {
    supported_locales = [
      "en",
      "nl",
    ]
    default_locale = "en"
  }

  #registration_flow = "upg-registration-flow" //needs to be plain text alias
  #browser_flow      = "upg-sso-browser-flow"

  smtp_server {
    host              = "smtp.eu.mailgun.org"
    port              = 465
    from_display_name = "Unifiedpost Group"
    from              = "postmaster@iam-mg.uat.unifiedpost.com"
    starttls          = true
    ssl               = true
    auth {
      username = "postmaster@iam-mg.uat.unifiedpost.com"
      password = module.smtp-server-auth-password.secret_value
    }
  }

  #password_policy = "length(8) and upperCase(1) and lowerCase(1) and specialChars(1) and digits(1)"

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
  revoke_refresh_token    = true
  refresh_token_max_reuse = 0
  ssl_required            = "external"

  attributes = {
    smsGatewayEnable           = false
    otpAllowedRecoveryChannels = "email"
    pinCodeMaxTime             = 10
    pinCodeMaxUnit             = "Minutes"
    frontendUrl                = "https://iam.uat.unifiedpost.com/auth/"
    registrationDataSecret     = module.fab-upg-sso_registration-data-secret.secret_value

    idpForUpProductsFallback              = false
    idpForUpProducts-eherkenning          = "billtoboxnl,Billtoboxnl,agrobox,banqupnl,account,onea-eis,onea-upconstruct"
    idpForUpProducts-iam-baltics-idcard   = "account,banquplv,banquplt,banqupee,billtoboxee,billtoboxlv,billtoboxlt"
    idpForUpProducts-iam-baltics-mobileid = "account,banquplv,banquplt,banqupee,billtoboxee,billtoboxlv,billtoboxlt"
    idpForUpProducts-iam-baltics-smartid  = "account,banquplv,banquplt,banqupee,billtoboxee,billtoboxlv,billtoboxlt"
    idpForUpProducts-franceconnect        = "onea-fr"
    idpForUpProducts-google               = "adminbox,onea-be,onea-eis,onea-upconstruct,onea-fr"
    idpForUpProducts-itsme                = "onea-be,onea-eis"
    idpForUpProducts-zlogin               = "billtoboxnl,Billtoboxnl,agrobox,account,onea-eis,onea-upconstruct"

    upProductForLocales-adminbox    = "nl,en"
    upProductForLocales-agrobox     = "nl,en"
    upProductForLocales-billtoboxnl = "nl,en"
    upProductForLocales-zlogin      = "nl,en"
  }
}

module "fab-upg-sso_registration-data-secret" {
  source      = "../../../modules/aws_secretsmanager_secret_value"
  secret_path = "/${var.project}/${var.subproject}/${var.env}/containers/keycloak/config/fab-upg-sso/registration-data-secret"
}

resource "keycloak_custom_user_federation" "fab-upg-sso_upg-community-user-provider5" {
  provider_id  = "upg-community-user-provider5"
  name         = "upg-community-user-provider5"
  realm_id     = keycloak_realm.fab-upg-sso.id
  enabled      = true
  priority     = "0"
  cache_policy = "DEFAULT"
  config = {
    usersApiUrl                  = "https://apps-users-api-uat-1-2.nxt.uat.unifiedpost.com/users"
    usersApiToken                = module.fab-upg-sso-upg-user-api-provider_users-api-token.secret_value
    communityApiUrl              = "https://community-api-uat-1-2.nxt.uat.unifiedpost.com/api"
    communityApiBasicAuthUser    = "external_user"
    communityApiBasicAuthPass    = module.fab-upg-sso-upg-user-api-provider_community-api-basic-auth-pass.secret_value
    communityApiVasBasicAuthUser = "syncasso"
    communityApiVasBasicAuthPass = module.fab-upg-sso-upg-user-api-provider_community-api-vas-basic-auth-pass.secret_value
    restApiBasicAuthUser         = "external_user"
    restApiBasicAuthPass         = module.fab-upg-sso-upg-user-api-provider_rest-api-basic-auth-pass.secret_value
  }
}

module "fab-upg-sso-upg-user-api-provider_users-api-token" {
  source      = "../../../modules/aws_secretsmanager_secret_value"
  secret_path = "/${var.project}/${var.subproject}/${var.env}/containers/keycloak/config/fab-upg-sso/upg-user-api-provider/users-api-token"
}

module "fab-upg-sso-upg-user-api-provider_community-api-basic-auth-pass" {
  source      = "../../../modules/aws_secretsmanager_secret_value"
  secret_path = "/${var.project}/${var.subproject}/${var.env}/containers/keycloak/config/fab-upg-sso/upg-user-api-provider/community-api-basic-auth-pass"
}

module "fab-upg-sso-upg-user-api-provider_community-api-vas-basic-auth-pass" {
  source      = "../../../modules/aws_secretsmanager_secret_value"
  secret_path = "/${var.project}/${var.subproject}/${var.env}/containers/keycloak/config/fab-upg-sso/upg-user-api-provider/community-api-vas-basic-auth-pass"
}

module "fab-upg-sso-upg-user-api-provider_rest-api-basic-auth-pass" {
  source      = "../../../modules/aws_secretsmanager_secret_value"
  secret_path = "/${var.project}/${var.subproject}/${var.env}/containers/keycloak/config/fab-upg-sso/upg-user-api-provider/rest-api-basic-auth-pass"
}

module "smtp-server-auth-password" {
  source      = "../../../modules/aws_secretsmanager_secret_value"
  secret_path = "/${var.project}/${var.subproject}/${var.env}/containers/keycloak/config/smtp-server-auth-password"
}

output "keycloak_realm_id" {
  value = keycloak_realm.fab-upg-sso.id
}
