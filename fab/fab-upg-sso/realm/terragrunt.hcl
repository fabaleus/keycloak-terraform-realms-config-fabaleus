# stage/upg-sso/terragrunt.hcl
include {
  path = find_in_parent_folders()
}
# sequence on dependancies: realm <- flows <- clients <- idps
# from the ../realms/[realmname] --> idps
