locals {
  realm_id = replace(var.path_relative_to_include, "/flows", "")
}
#########################
# browser-with-up-product-otp-v2
#########################
# LEVEL0
resource "keycloak_authentication_flow" "browser-with-up-product-otp-v2" {
  alias       = "browser-with-up-product-otp-v2"
  realm_id    = local.realm_id
  description = "browser based authentication"
}
# LEVEL1.1
resource "keycloak_authentication_execution" "browser-with-up-product-otp-v2_up-debug_1_1" {
  realm_id          = local.realm_id
  parent_flow_alias = keycloak_authentication_flow.browser-with-up-product-otp-v2.alias
  authenticator     = "up-debug"
  requirement       = "REQUIRED"
}

# LEVEL1.1 (config)
resource "keycloak_authentication_execution_config" "browser-with-up-product-otp-v2_up-debug_1_1_config1_1" {
  realm_id     = local.realm_id
  execution_id = keycloak_authentication_execution.browser-with-up-product-otp-v2_up-debug_1_1.id
  alias        = "browser-with-up-product-otp-v2_up-debug_1_1_config1_1"
  config = {
  }
}

# LEVEL1.2
resource "keycloak_authentication_execution" "browser-with-up-product-otp-v2_up-product-query-param-reader_1_2" {
  realm_id          = local.realm_id
  parent_flow_alias = keycloak_authentication_flow.browser-with-up-product-otp-v2.alias
  authenticator     = "up-product-query-param-reader"
  requirement       = "REQUIRED"
  depends_on        = [keycloak_authentication_execution.browser-with-up-product-otp-v2_up-debug_1_1]
}

# LEVEL1.3
resource "keycloak_authentication_execution" "browser-with-up-product-otp-v2_up-session-note-setter_1_3" {
  realm_id          = local.realm_id
  parent_flow_alias = keycloak_authentication_flow.browser-with-up-product-otp-v2.alias
  authenticator     = "up-session-note-setter"
  requirement       = "REQUIRED"
  depends_on        = [keycloak_authentication_execution.browser-with-up-product-otp-v2_up-product-query-param-reader_1_2]
}

# LEVEL1.3 (config)
resource "keycloak_authentication_execution_config" "browser-with-up-product-otp-v2_up-session-note-setter_1_3_config1_3" {
  realm_id     = local.realm_id
  execution_id = keycloak_authentication_execution.browser-with-up-product-otp-v2_up-session-note-setter_1_3.id
  alias        = "browser-with-up-product-otp-v2_up-session-note-setter_1_3_config1_3"
  config = {
    user_session_note_key_and_query_param_key = "[{\"key\":\"up_custom_data\",\"value\":\"up-custom-data\"}]"
  }
}

# LEVEL1.4
resource "keycloak_authentication_execution" "browser-with-up-product-otp-v2_up-user-data-reader_1_4" {
  realm_id          = local.realm_id
  parent_flow_alias = keycloak_authentication_flow.browser-with-up-product-otp-v2.alias
  authenticator     = "up-user-data-reader"
  requirement       = "REQUIRED"
  depends_on        = [keycloak_authentication_execution.browser-with-up-product-otp-v2_up-session-note-setter_1_3]
}

# LEVEL1.5: SUBFLOW wrapper
resource "keycloak_authentication_subflow" "browser-with-up-product-otp-v2-browser-with-up-product-otp-Cookie-or-redirector-or-form" {
  realm_id          = local.realm_id
  parent_flow_alias = keycloak_authentication_flow.browser-with-up-product-otp-v2.alias
  alias             = "browser-with-up-product-otp-v2-browser-with-up-product-otp-Cookie-or-redirector-or-form"
  requirement       = "REQUIRED"
  depends_on        = [keycloak_authentication_execution.browser-with-up-product-otp-v2_up-user-data-reader_1_4]
}

# LEVEL2.1
resource "keycloak_authentication_execution" "browser-with-up-product-otp-v2-browser-with-up-product-otp-Cookie-or-redirector-or-form_auth-cookie_2_1" {
  realm_id          = local.realm_id
  parent_flow_alias = keycloak_authentication_subflow.browser-with-up-product-otp-v2-browser-with-up-product-otp-Cookie-or-redirector-or-form.alias
  authenticator     = "auth-cookie"
  requirement       = "ALTERNATIVE"
}

# LEVEL2.2
resource "keycloak_authentication_execution" "browser-with-up-product-otp-v2-browser-with-up-product-otp-Cookie-or-redirector-or-form_up-identity-provider-redirector_2_2" {
  realm_id          = local.realm_id
  parent_flow_alias = keycloak_authentication_subflow.browser-with-up-product-otp-v2-browser-with-up-product-otp-Cookie-or-redirector-or-form.alias
  authenticator     = "up-identity-provider-redirector"
  requirement       = "ALTERNATIVE"
  depends_on        = [keycloak_authentication_execution.browser-with-up-product-otp-v2-browser-with-up-product-otp-Cookie-or-redirector-or-form_auth-cookie_2_1]
}

# LEVEL2.3: SUBFLOW wrapper
resource "keycloak_authentication_subflow" "browser-with-up-product-otp-v2-browser-with-up-product-otp-Browser-user-password-forms" {
  realm_id          = local.realm_id
  parent_flow_alias = keycloak_authentication_subflow.browser-with-up-product-otp-v2-browser-with-up-product-otp-Cookie-or-redirector-or-form.alias
  alias             = "browser-with-up-product-otp-v2-browser-with-up-product-otp-Browser-user-password-forms"
  requirement       = "ALTERNATIVE"
  depends_on        = [keycloak_authentication_execution.browser-with-up-product-otp-v2-browser-with-up-product-otp-Cookie-or-redirector-or-form_up-identity-provider-redirector_2_2]
}

# LEVEL3.1
resource "keycloak_authentication_execution" "browser-with-up-product-otp-v2-browser-with-up-product-otp-Browser-user-password-forms_recovery-auth-username-password-form_3_1" {
  realm_id          = local.realm_id
  parent_flow_alias = keycloak_authentication_subflow.browser-with-up-product-otp-v2-browser-with-up-product-otp-Browser-user-password-forms.alias
  authenticator     = "recovery-auth-username-password-form"
  requirement       = "REQUIRED"
}

# LEVEL3.1 (config)
resource "keycloak_authentication_execution_config" "browser-with-up-product-otp-v2-browser-with-up-product-otp-Browser-user-password-forms_recovery-auth-username-password-form_3_1_config3_1" {
  realm_id     = local.realm_id
  execution_id = keycloak_authentication_execution.browser-with-up-product-otp-v2-browser-with-up-product-otp-Browser-user-password-forms_recovery-auth-username-password-form_3_1.id
  alias        = "browser-with-up-product-otp-v2-browser-with-up-product-otp-Browser-user-password-forms_recovery-auth-username-password-form_3_1_config3_1"
  config = {
    "block.username.password.login.when.user.has.idps" = "false"
  }
}

# LEVEL3.2
resource "keycloak_authentication_execution" "browser-with-up-product-otp-v2-browser-with-up-product-otp-Browser-user-password-forms_augment-security_3_2" {
  realm_id          = local.realm_id
  parent_flow_alias = keycloak_authentication_subflow.browser-with-up-product-otp-v2-browser-with-up-product-otp-Browser-user-password-forms.alias
  authenticator     = "augment-security"
  requirement       = "REQUIRED"
  depends_on        = [keycloak_authentication_execution.browser-with-up-product-otp-v2-browser-with-up-product-otp-Browser-user-password-forms_recovery-auth-username-password-form_3_1]
}

# LEVEL3.2 (config)
resource "keycloak_authentication_execution_config" "browser-with-up-product-otp-v2-browser-with-up-product-otp-Browser-user-password-forms_augment-security_3_2_config3_2" {
  realm_id     = local.realm_id
  execution_id = keycloak_authentication_execution.browser-with-up-product-otp-v2-browser-with-up-product-otp-Browser-user-password-forms_augment-security_3_2.id
  alias        = "browser-with-up-product-otp-v2-browser-with-up-product-otp-Browser-user-password-forms_augment-security_3_2_config3_2"
  config = {
    augmentedSecurityNumberOfDaysBetween = "-1"
    "show.skip.part"                     = "true"
    "show.idp.part"                      = "true"
    "show.totp.part"                     = "true"
  }
}

# LEVEL3.3
resource "keycloak_authentication_execution" "browser-with-up-product-otp-v2-browser-with-up-product-otp-Browser-user-password-forms_up-identity-provider-link-redirector_3_3" {
  realm_id          = local.realm_id
  parent_flow_alias = keycloak_authentication_subflow.browser-with-up-product-otp-v2-browser-with-up-product-otp-Browser-user-password-forms.alias
  authenticator     = "up-identity-provider-link-redirector"
  requirement       = "REQUIRED"
  depends_on        = [keycloak_authentication_execution.browser-with-up-product-otp-v2-browser-with-up-product-otp-Browser-user-password-forms_augment-security_3_2]
}

# LEVEL3.4
resource "keycloak_authentication_execution" "browser-with-up-product-otp-v2-browser-with-up-product-otp-Browser-user-password-forms_up-session-note-setter_3_4" {
  realm_id          = local.realm_id
  parent_flow_alias = keycloak_authentication_subflow.browser-with-up-product-otp-v2-browser-with-up-product-otp-Browser-user-password-forms.alias
  authenticator     = "up-session-note-setter"
  requirement       = "REQUIRED"
  depends_on        = [keycloak_authentication_execution.browser-with-up-product-otp-v2-browser-with-up-product-otp-Browser-user-password-forms_up-identity-provider-link-redirector_3_3]
}

# LEVEL3.4 (config)
resource "keycloak_authentication_execution_config" "browser-with-up-product-otp-v2-browser-with-up-product-otp-Browser-user-password-forms_up-session-note-setter_3_4_config3_4" {
  realm_id     = local.realm_id
  execution_id = keycloak_authentication_execution.browser-with-up-product-otp-v2-browser-with-up-product-otp-Browser-user-password-forms_up-session-note-setter_3_4.id
  alias        = "browser-with-up-product-otp-v2-browser-with-up-product-otp-Browser-user-password-forms_up-session-note-setter_3_4_config3_4"
  config = {
    user_session_note_key_and_value = "[{\"key\":\"up:sso:sess:acr\",\"value\":\"0\"},{\"key\":\"up:sso:sess:idp\",\"value\":\"keycloak\"}]"
  }
}

# LEVEL3.5: SUBFLOW wrapper
resource "keycloak_authentication_subflow" "Browser---Conditional-OTP---v2" {
  realm_id          = local.realm_id
  parent_flow_alias = keycloak_authentication_subflow.browser-with-up-product-otp-v2-browser-with-up-product-otp-Browser-user-password-forms.alias
  alias             = "Browser---Conditional-OTP---v2"
  requirement       = "CONDITIONAL"
  depends_on        = [keycloak_authentication_execution.browser-with-up-product-otp-v2-browser-with-up-product-otp-Browser-user-password-forms_up-session-note-setter_3_4]
}

# LEVEL4.1
resource "keycloak_authentication_execution" "Browser---Conditional-OTP---v2_conditional-user-configured_4_1" {
  realm_id          = local.realm_id
  parent_flow_alias = keycloak_authentication_subflow.Browser---Conditional-OTP---v2.alias
  authenticator     = "conditional-user-configured"
  requirement       = "REQUIRED"
}

# LEVEL4.2
resource "keycloak_authentication_execution" "Browser---Conditional-OTP---v2_recovery-auth-otp-form_4_2" {
  realm_id          = local.realm_id
  parent_flow_alias = keycloak_authentication_subflow.Browser---Conditional-OTP---v2.alias
  authenticator     = "recovery-auth-otp-form"
  requirement       = "REQUIRED"
  depends_on        = [keycloak_authentication_execution.Browser---Conditional-OTP---v2_conditional-user-configured_4_1]
}

# LEVEL4.2 (config)
resource "keycloak_authentication_execution_config" "Browser---Conditional-OTP---v2_recovery-auth-otp-form_4_2_config4_2" {
  realm_id     = local.realm_id
  execution_id = keycloak_authentication_execution.Browser---Conditional-OTP---v2_recovery-auth-otp-form_4_2.id
  alias        = "Browser---Conditional-OTP---v2_recovery-auth-otp-form_4_2_config4_2"
  config = {
    OTP_REMEMBER_ME_EXPIRES_IN_DAYS = "30"
  }
}

# LEVEL4.3
resource "keycloak_authentication_execution" "Browser---Conditional-OTP---v2_up-session-note-setter_4_3" {
  realm_id          = local.realm_id
  parent_flow_alias = keycloak_authentication_subflow.Browser---Conditional-OTP---v2.alias
  authenticator     = "up-session-note-setter"
  requirement       = "REQUIRED"
  depends_on        = [keycloak_authentication_execution.Browser---Conditional-OTP---v2_recovery-auth-otp-form_4_2]
}

# LEVEL4.3 (config)
resource "keycloak_authentication_execution_config" "Browser---Conditional-OTP---v2_up-session-note-setter_4_3_config4_3" {
  realm_id     = local.realm_id
  execution_id = keycloak_authentication_execution.Browser---Conditional-OTP---v2_up-session-note-setter_4_3.id
  alias        = "Browser---Conditional-OTP---v2_up-session-note-setter_4_3_config4_3"
  config = {
    user_session_note_key_and_value = "[{\"key\":\"up:sso:sess:acr\",\"value\":\"100\"},{\"key\":\"up:sso:sess:idp\",\"value\":\"keycloak\"}]"
  }
}

# LEVEL1.6
resource "keycloak_authentication_execution" "browser-with-up-product-otp-v2_up-debug_1_6" {
  realm_id          = local.realm_id
  parent_flow_alias = keycloak_authentication_flow.browser-with-up-product-otp-v2.alias
  authenticator     = "up-debug"
  requirement       = "REQUIRED"
  depends_on        = [keycloak_authentication_execution.Browser---Conditional-OTP---v2_up-session-note-setter_4_3]
}

# LEVEL1.6 (config)
resource "keycloak_authentication_execution_config" "browser-with-up-product-otp-v2_up-debug_1_6_config1_6" {
  realm_id     = local.realm_id
  execution_id = keycloak_authentication_execution.browser-with-up-product-otp-v2_up-debug_1_6.id
  alias        = "browser-with-up-product-otp-v2_up-debug_1_6_config1_6"
  config = {
  }
}

# LEVEL1.7: SUBFLOW wrapper
resource "keycloak_authentication_subflow" "browser-with-up-product-otp-v2-acr_100_flow" {
  realm_id          = local.realm_id
  parent_flow_alias = keycloak_authentication_flow.browser-with-up-product-otp-v2.alias
  alias             = "browser-with-up-product-otp-v2-acr_100_flow"
  requirement       = "CONDITIONAL"
  depends_on        = [keycloak_authentication_execution.browser-with-up-product-otp-v2_up-debug_1_6]
}

# LEVEL2.1
resource "keycloak_authentication_execution" "browser-with-up-product-otp-v2-acr_100_flow_up-cond-acr_val-not-sess-note-int_2_1" {
  realm_id          = local.realm_id
  parent_flow_alias = keycloak_authentication_subflow.browser-with-up-product-otp-v2-acr_100_flow.alias
  authenticator     = "up-cond-acr_val-not-sess-note-int"
  requirement       = "REQUIRED"
}

# LEVEL2.1 (config)
resource "keycloak_authentication_execution_config" "browser-with-up-product-otp-v2-acr_100_flow_up-cond-acr_val-not-sess-note-int_2_1_config2_1" {
  realm_id     = local.realm_id
  execution_id = keycloak_authentication_execution.browser-with-up-product-otp-v2-acr_100_flow_up-cond-acr_val-not-sess-note-int_2_1.id
  alias        = "browser-with-up-product-otp-v2-acr_100_flow_up-cond-acr_val-not-sess-note-int_2_1_config2_1"
  config = {
    config_param_matching_acr_value        = "100"
    config_param_operator                  = "less"
    config_param_int_value                 = "1"
    config_param_matching_session_note_key = "up:sso:sess:acr"
  }
}

# LEVEL2.2
resource "keycloak_authentication_execution" "browser-with-up-product-otp-v2-acr_100_flow_up-cancelable-auth-otp-form_2_2" {
  realm_id          = local.realm_id
  parent_flow_alias = keycloak_authentication_subflow.browser-with-up-product-otp-v2-acr_100_flow.alias
  authenticator     = "up-cancelable-auth-otp-form"
  requirement       = "REQUIRED"
  depends_on        = [keycloak_authentication_execution.browser-with-up-product-otp-v2-acr_100_flow_up-cond-acr_val-not-sess-note-int_2_1]
}

# LEVEL2.3: SUBFLOW wrapper
resource "keycloak_authentication_subflow" "browser-with-up-product-otp-v2-UP_SSO_SESS_acr_100_setter" {
  realm_id          = local.realm_id
  parent_flow_alias = keycloak_authentication_subflow.browser-with-up-product-otp-v2-acr_100_flow.alias
  alias             = "browser-with-up-product-otp-v2-UP_SSO_SESS_acr_100_setter"
  requirement       = "CONDITIONAL"
  depends_on        = [keycloak_authentication_execution.browser-with-up-product-otp-v2-acr_100_flow_up-cancelable-auth-otp-form_2_2]
}

# LEVEL3.1
resource "keycloak_authentication_execution" "browser-with-up-product-otp-v2-UP_SSO_SESS_acr_100_setter_up-cond-acr_val-not-sess-note-int_3_1" {
  realm_id          = local.realm_id
  parent_flow_alias = keycloak_authentication_subflow.browser-with-up-product-otp-v2-UP_SSO_SESS_acr_100_setter.alias
  authenticator     = "up-cond-acr_val-not-sess-note-int"
  requirement       = "REQUIRED"
}

# LEVEL3.1 (config)
resource "keycloak_authentication_execution_config" "browser-with-up-product-otp-v2-UP_SSO_SESS_acr_100_setter_up-cond-acr_val-not-sess-note-int_3_1_config3_1" {
  realm_id     = local.realm_id
  execution_id = keycloak_authentication_execution.browser-with-up-product-otp-v2-UP_SSO_SESS_acr_100_setter_up-cond-acr_val-not-sess-note-int_3_1.id
  alias        = "browser-with-up-product-otp-v2-UP_SSO_SESS_acr_100_setter_up-cond-acr_val-not-sess-note-int_3_1_config3_1"
  config = {
    config_param_matching_acr_value        = "100"
    config_param_int_value                 = "1"
    config_param_operator                  = "less"
    config_param_matching_session_note_key = "OTP_SKIPPED"
  }
}

# LEVEL3.2
resource "keycloak_authentication_execution" "browser-with-up-product-otp-v2-UP_SSO_SESS_acr_100_setter_up-session-note-setter_3_2" {
  realm_id          = local.realm_id
  parent_flow_alias = keycloak_authentication_subflow.browser-with-up-product-otp-v2-UP_SSO_SESS_acr_100_setter.alias
  authenticator     = "up-session-note-setter"
  requirement       = "REQUIRED"
  depends_on        = [keycloak_authentication_execution.browser-with-up-product-otp-v2-UP_SSO_SESS_acr_100_setter_up-cond-acr_val-not-sess-note-int_3_1]
}

# LEVEL3.2 (config)
resource "keycloak_authentication_execution_config" "browser-with-up-product-otp-v2-UP_SSO_SESS_acr_100_setter_up-session-note-setter_3_2_config3_2" {
  realm_id     = local.realm_id
  execution_id = keycloak_authentication_execution.browser-with-up-product-otp-v2-UP_SSO_SESS_acr_100_setter_up-session-note-setter_3_2.id
  alias        = "browser-with-up-product-otp-v2-UP_SSO_SESS_acr_100_setter_up-session-note-setter_3_2_config3_2"
  config = {
    client_session_note_key_and_value = "[{\"key\":\"up:sso:sess:acr\",\"value\":\"101\"}]"
    user_session_note_key_and_value   = "[{\"key\":\"up:sso:sess:acr\",\"value\":\"100\"}]"
  }
}

# LEVEL1.8
resource "keycloak_authentication_execution" "browser-with-up-product-otp-v2_up-debug_1_8" {
  realm_id          = local.realm_id
  parent_flow_alias = keycloak_authentication_flow.browser-with-up-product-otp-v2.alias
  authenticator     = "up-debug"
  requirement       = "REQUIRED"
  depends_on        = [keycloak_authentication_execution.browser-with-up-product-otp-v2-UP_SSO_SESS_acr_100_setter_up-session-note-setter_3_2]
}

# LEVEL1.8 (config)
resource "keycloak_authentication_execution_config" "browser-with-up-product-otp-v2_up-debug_1_8_config1_8" {
  realm_id     = local.realm_id
  execution_id = keycloak_authentication_execution.browser-with-up-product-otp-v2_up-debug_1_8.id
  alias        = "browser-with-up-product-otp-v2_up-debug_1_8_config1_8"
  config = {
  }
}

# LEVEL1.9
resource "keycloak_authentication_execution" "browser-with-up-product-otp-v2_up-products-user-attr-setter_1_9" {
  realm_id          = local.realm_id
  parent_flow_alias = keycloak_authentication_flow.browser-with-up-product-otp-v2.alias
  authenticator     = "up-products-user-attr-setter"
  requirement       = "REQUIRED"
  depends_on        = [keycloak_authentication_execution.browser-with-up-product-otp-v2_up-debug_1_8]
}

output "browser-with-up-product-otp-v2-alias" {
  value = keycloak_authentication_flow.browser-with-up-product-otp-v2.alias
}
