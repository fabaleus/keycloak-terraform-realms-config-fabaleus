#version1.2
locals {
  realm_id = replace(var.path_relative_to_include, "/clients", "")

  valid_redirect_uris = (var.env == "fab" ? ["https://iam.uat.unifiedpost.com/auth/realms/fab-iam-debug/broker/upg-sso/endpoint*"] :
  ["https://dummy"])
}

resource "keycloak_openid_client" "fab-iam-debug-realm" {
  client_id = "fab-iam-debug"
  realm_id  = local.realm_id

  access_type           = "CONFIDENTIAL"
  client_secret         = module.fab-iam-debug-realm_secret.secret_value
  standard_flow_enabled = true
  login_theme           = "community-1203.0.0"

  valid_redirect_uris = local.valid_redirect_uris
}

output "fab_iam_debug_client_id" {
  value = keycloak_openid_client.fab-iam-debug-realm.id
}

module "fab-iam-debug-realm_secret" {
  source      = "../../../modules/aws_secretsmanager_secret_value"
  secret_path = "/${var.project}/${var.subproject}/${var.env}/containers/keycloak/config/${local.realm_id}/fab-iam-debug-realm_client-secret"
}
