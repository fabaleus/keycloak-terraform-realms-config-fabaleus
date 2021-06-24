terraform {
  required_version = ">= 0.13"

  required_providers {
    keycloak = {
      source  = "mrparkers/keycloak"
      version = ">= 2.0.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.23"
    }
  }
}

data "keycloak_openid_client" "realm_client" {
  realm_id  = var.master_realm_id
  client_id = var.client_other_realm_id
}

data "keycloak_role" "realm_client_create-client_role" {
  realm_id = var.master_realm_id
  client_id = data.keycloak_openid_client.realm_client.id
  name = "create-client"
}

data "keycloak_role" "realm_client_impersonation_role" {
  realm_id = var.master_realm_id
  client_id = data.keycloak_openid_client.realm_client.id
  name = "impersonation"
}

data "keycloak_role" "realm_client_manage-authorization_role" {
  realm_id = var.master_realm_id
  client_id = data.keycloak_openid_client.realm_client.id
  name = "manage-authorization"
}

data "keycloak_role" "realm_client_manage-clients_role" {
  realm_id = var.master_realm_id
  client_id = data.keycloak_openid_client.realm_client.id
  name = "manage-clients"
}

data "keycloak_role" "realm_client_manage-events_role" {
  realm_id = var.master_realm_id
  client_id = data.keycloak_openid_client.realm_client.id
  name = "manage-events"
}

data "keycloak_role" "realm_client_manage-identity-providers_role" {
  realm_id = var.master_realm_id
  client_id = data.keycloak_openid_client.realm_client.id
  name = "manage-identity-providers"
}

data "keycloak_role" "realm_client_manage-realm_role" {
  realm_id = var.master_realm_id
  client_id = data.keycloak_openid_client.realm_client.id
  name = "manage-realm"
}

data "keycloak_role" "realm_client_manage-users_role" {
  realm_id = var.master_realm_id
  client_id = data.keycloak_openid_client.realm_client.id
  name = "manage-users"
}

// data "keycloak_role" "realm_client_query-clients_role" {
//   realm_id = var.master_realm_id
//   client_id = data.keycloak_openid_client.realm_client.id
//   name = "query-clients"
// }

// data "keycloak_role" "realm_client_query-groups_role" {
//   realm_id = var.master_realm_id
//   client_id = data.keycloak_openid_client.realm_client.id
//   name = "query-groups"
// }

// data "keycloak_role" "realm_client_query-realms_role" {
//   realm_id = var.master_realm_id
//   client_id = data.keycloak_openid_client.realm_client.id
//   name = "query-realms"
// }

// data "keycloak_role" "realm_client_query-users_role" {
//   realm_id = var.master_realm_id
//   client_id = data.keycloak_openid_client.realm_client.id
//   name = "query-users"
// }

data "keycloak_role" "realm_client_view-authorization_role" {
  realm_id = var.master_realm_id
  client_id = data.keycloak_openid_client.realm_client.id
  name = "view-authorization"
}

data "keycloak_role" "realm_client_view-clients_role" {
  realm_id = var.master_realm_id
  client_id = data.keycloak_openid_client.realm_client.id
  name = "view-clients"
}

data "keycloak_role" "realm_client_view-events_role" {
  realm_id = var.master_realm_id
  client_id = data.keycloak_openid_client.realm_client.id
  name = "view-events"
}

data "keycloak_role" "realm_client_view-identity-providers_role" {
  realm_id = var.master_realm_id
  client_id = data.keycloak_openid_client.realm_client.id
  name = "view-identity-providers"
}

data "keycloak_role" "realm_client_view-realm_role" {
  realm_id = var.master_realm_id
  client_id = data.keycloak_openid_client.realm_client.id
  name = "view-realm"
}

data "keycloak_role" "realm_client_view-users_role" {
  realm_id = var.master_realm_id
  client_id = data.keycloak_openid_client.realm_client.id
  name = "view-users"
}

resource "keycloak_group" "keycloak_admin_group" {
    realm_id = var.master_realm_id
    name     = "${var.client_other_realm_id}_admin"
}

resource "keycloak_group_roles" "keycloak_admin_group_roles" {
  realm_id = var.master_realm_id
  group_id = keycloak_group.keycloak_admin_group.id

  role_ids = [
      data.keycloak_role.realm_client_create-client_role.id,
      data.keycloak_role.realm_client_impersonation_role.id,
      data.keycloak_role.realm_client_manage-authorization_role.id,
      data.keycloak_role.realm_client_manage-clients_role.id,
      data.keycloak_role.realm_client_manage-events_role.id,
      data.keycloak_role.realm_client_manage-identity-providers_role.id,
      data.keycloak_role.realm_client_manage-realm_role.id,
      data.keycloak_role.realm_client_manage-users_role.id,
      // data.keycloak_role.realm_client_query-clients_role.id,
      // data.keycloak_role.realm_client_query-groups_role.id,
      // data.keycloak_role.realm_client_query-realms_role.id,
      // data.keycloak_role.realm_client_query-users_role.id,
      data.keycloak_role.realm_client_view-authorization_role.id,
      data.keycloak_role.realm_client_view-clients_role.id,
      data.keycloak_role.realm_client_view-events_role.id,
      data.keycloak_role.realm_client_view-identity-providers_role.id,
      data.keycloak_role.realm_client_view-realm_role.id,
      data.keycloak_role.realm_client_view-users_role.id
  ]
}