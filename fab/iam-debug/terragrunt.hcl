# fab/iam-debug/terragrunt.hcl
include {
  path = find_in_parent_folders()
}

dependency "upg-sso" {
  config_path = "../upg-sso"
}

inputs = {
  upg_sso_realm_id = dependency.upg-sso.outputs.keycloak_realm_fab-upg-sso_id
  upg_sso_realm_client_id = dependency.upg-sso.outputs.upg-sso_fab-iam-debug-client_id
}
