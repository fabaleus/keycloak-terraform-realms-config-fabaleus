output "group_id" {
  value = keycloak_group.keycloak_manage_users_group.id
}

//This module create a manage_users-group in the master realm with the manage user role for a specific other realm via the other-realm-client
//it outputs the group id, you can make users member of this group
//example:
// module "keycloak_realm_manage_users_group" {
//   source      = "../modules/keycloak_realm_manage_users_group"
//   master_realm_id = keycloak_realm.master.id
//   client_other_realm_id = "my-otherrealm-realm"
// }

//use group id in keycloak_group_memberships
// resource "keycloak_group_memberships" "my_members" {
//   realm_id = keycloak_realm.master.id
//   group_id = module.keycloak_realm_manage_users_group.group_id

//   members = []
// }
