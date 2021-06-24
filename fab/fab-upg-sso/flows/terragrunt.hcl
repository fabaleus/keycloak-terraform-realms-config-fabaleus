# stage/upg-sso/terragrunt.hcl
include {
  path = find_in_parent_folders()
}
# sequence on dependancies: realm <- flows <- clients <- idps
# from the ../realms/[realmname] --> idps
dependency "realm" {
  config_path  = "../realm"
}
inputs = {
  realm_id = dependency.realm.outputs.keycloak_realm_id
}
