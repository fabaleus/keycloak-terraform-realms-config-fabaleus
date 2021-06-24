include {
  path = find_in_parent_folders()
}

# sequence on dependancies: realm <- flows <- clients <- idps
# from the ../realms/[realmname] --> idps
dependency "clients" {
  config_path  = "../clients"
}

inputs = {
  fab_iam_debug_client_id  = lookup(dependency.clients.outputs, "fab_iam_debug_client_id", "mock-client-id")
}
