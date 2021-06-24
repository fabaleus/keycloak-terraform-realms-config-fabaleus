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

data "keycloak_role" "realm_client_manage-users_role"{
  realm_id  = var.master_realm_id
  client_id = data.keycloak_openid_client.realm_client.id
  name      = "manage-users"
}

data "keycloak_role" "realm_client_view-users_role"{
  realm_id  = var.master_realm_id
  client_id = data.keycloak_openid_client.realm_client.id
  name      = "view-users"
}

resource "keycloak_group" "keycloak_manage_users_group" {
    realm_id = var.master_realm_id
    name     = "${var.client_other_realm_id}_manage-users"
}

resource "keycloak_group_roles" "keycloak_manage_users_group_roles" {
  realm_id = var.master_realm_id
  group_id = keycloak_group.keycloak_manage_users_group.id

  role_ids = [
      data.keycloak_role.realm_client_manage-users_role.id,
      data.keycloak_role.realm_client_view-users_role.id
  ]
}