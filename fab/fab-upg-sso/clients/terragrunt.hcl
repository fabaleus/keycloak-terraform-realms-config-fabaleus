# stage/upg-sso/terragrunt.hcl
include {
  path = find_in_parent_folders()
}

# sequence on dependancies: realm <- flows <- clients <- idps
# from the ../realms/[realmname] --> idps
dependency "flows" {
  config_path  = "../flows"
  mock_outputs = {
    browser-with-up-product-otp-v2-alias = "fake-alias"
  }
}
inputs = {
  flow_id = dependency.flows.outputs.browser-with-up-product-otp-v2-alias
}
