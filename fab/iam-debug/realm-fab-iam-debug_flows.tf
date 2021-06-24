
#########################
# Pentest Browser flow  #
#########################
#LEVEL0
resource "keycloak_authentication_flow" "fab-iam-debug-browser-flow" {
  alias       = "pentest-browser-flow"
  realm_id    = keycloak_realm.fab-iam-debug.id
  description = "Unifiedpost UPG SSO browser flow"
}

#LEVEL1.1
resource "keycloak_authentication_execution" "fab-iam-debug-browser-flow_up-product-query-param-reader" {
  realm_id          = keycloak_realm.fab-iam-debug.id
  parent_flow_alias = keycloak_authentication_flow.fab-iam-debug-browser-flow.alias
  authenticator     = "up-product-query-param-reader"
  requirement       = "REQUIRED"
}

#LEVEL1.2: SUBFLOW wrapper
resource "keycloak_authentication_subflow" "fab-iam-debug-browser-subflow" {
  realm_id          = keycloak_realm.fab-iam-debug.id
  parent_flow_alias = keycloak_authentication_flow.fab-iam-debug-browser-flow.alias
  alias             = "pentest-browser-subflow"
  requirement       = "REQUIRED"
  depends_on        = [keycloak_authentication_execution.fab-iam-debug-browser-flow_up-product-query-param-reader]
}

#LEVEL2.1
resource "keycloak_authentication_execution" "fab-iam-debug-browser-subflow_auth-cookie" {
  realm_id          = keycloak_realm.fab-iam-debug.id
  parent_flow_alias = keycloak_authentication_subflow.fab-iam-debug-browser-subflow.alias
  authenticator     = "auth-cookie"
  requirement       = "ALTERNATIVE"
}

#LEVEL2.2
resource "keycloak_authentication_execution" "fab-iam-debug-browser-subflow_up-identity-provider-redirector" {
  realm_id          = keycloak_realm.fab-iam-debug.id
  parent_flow_alias = keycloak_authentication_subflow.fab-iam-debug-browser-subflow.alias
  authenticator     = "up-identity-provider-redirector"
  requirement       = "ALTERNATIVE"
  depends_on        = [keycloak_authentication_execution.fab-iam-debug-browser-subflow_auth-cookie]
}

#LEVEL2.2 (config)
resource "keycloak_authentication_execution_config" "fab-iam-debug-browser-subflow_up-identity-provider-redirector_config" {
  realm_id     = keycloak_realm.fab-iam-debug.id
  execution_id = keycloak_authentication_execution.fab-iam-debug-browser-subflow_up-identity-provider-redirector.id
  alias        = "pentest-browser-subflow_up-identity-provider-redirector-config"
  config = {
    defaultProvider    = keycloak_oidc_identity_provider.fab-iam-debug-upg-sso_idp.alias
    redirectToRegister = false
  }
}

###############################
# Pentest first broker login  #
###############################
#LEVEL0
resource "keycloak_authentication_flow" "fab-iam-debug_upg-first-broker-login" {
  alias       = "upg-first-broker-login"
  realm_id    = keycloak_realm.fab-iam-debug.id
  description = "First broker upg login"
}

#LEVEL1.1
resource "keycloak_authentication_execution" "fab-iam-debug_upg-up-idp-create-user-if-unique" {
  realm_id          = keycloak_realm.fab-iam-debug.id
  parent_flow_alias = keycloak_authentication_flow.fab-iam-debug_upg-first-broker-login.alias
  authenticator     = "up-idp-create-user-if-unique"
  requirement       = "ALTERNATIVE"
}

#LEVEL1.2
resource "keycloak_authentication_execution" "fab-iam-debug_upg-idp-idp-auto-link" {
  realm_id          = keycloak_realm.fab-iam-debug.id
  parent_flow_alias = keycloak_authentication_flow.fab-iam-debug_upg-first-broker-login.alias
  authenticator     = "idp-auto-link"
  requirement       = "ALTERNATIVE"
  depends_on = [
    keycloak_authentication_execution.fab-iam-debug_upg-up-idp-create-user-if-unique
  ]
}

###############################
# Pentest Registration flow   #
###############################
#LEVEL0
resource "keycloak_authentication_flow" "fab-iam-debug-registration-flow" {
  alias       = "pentest-registration-flow"
  realm_id    = keycloak_realm.fab-iam-debug.id
  description = "Unifiedpost Pentest Registration flow"
}

#LEVEL1.1
resource "keycloak_authentication_execution" "fab-iam-debug-registration-flow_up-product-query-param-reader" {
  realm_id          = keycloak_realm.fab-iam-debug.id
  parent_flow_alias = keycloak_authentication_flow.fab-iam-debug-registration-flow.alias
  authenticator     = "up-product-query-param-reader"
  requirement       = "REQUIRED"
}


#LEVEL1.2: SUBFLOW wrapper
resource "keycloak_authentication_subflow" "fab-iam-debug-registration-subflow" {
  realm_id          = keycloak_realm.fab-iam-debug.id
  parent_flow_alias = keycloak_authentication_flow.fab-iam-debug-registration-flow.alias
  alias             = "pentest-registration-subflow"
  requirement       = "REQUIRED"
  depends_on        = [keycloak_authentication_execution.fab-iam-debug-registration-flow_up-product-query-param-reader]
}

#LEVEL2.1
resource "keycloak_authentication_execution" "fab-iam-debug-registration-subflow_auth-cookie" {
  realm_id          = keycloak_realm.fab-iam-debug.id
  parent_flow_alias = keycloak_authentication_subflow.fab-iam-debug-registration-subflow.alias
  authenticator     = "auth-cookie"
  requirement       = "ALTERNATIVE"
}

#LEVEL2.2
resource "keycloak_authentication_execution" "fab-iam-debug-registration-subflow_up-identity-provider-redirector" {
  realm_id          = keycloak_realm.fab-iam-debug.id
  parent_flow_alias = keycloak_authentication_subflow.fab-iam-debug-registration-subflow.alias
  authenticator     = "up-identity-provider-redirector"
  requirement       = "ALTERNATIVE"
  depends_on        = [keycloak_authentication_execution.fab-iam-debug-registration-subflow_auth-cookie]
}

#LEVEL2.2 (config)
resource "keycloak_authentication_execution_config" "fab-iam-debug-registration-subflow_up-identity-provider-redirector_config" {
  realm_id     = keycloak_realm.fab-iam-debug.id
  execution_id = keycloak_authentication_execution.fab-iam-debug-registration-subflow_up-identity-provider-redirector.id
  alias        = "pentest-registration-subflow_up-identity-provider-redirector-config"
  config = {
    defaultProvider    = keycloak_oidc_identity_provider.fab-iam-debug-upg-sso_idp.alias
    redirectToRegister = true
  }
}
