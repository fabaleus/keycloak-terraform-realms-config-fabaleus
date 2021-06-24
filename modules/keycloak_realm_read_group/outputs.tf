output "group_id" {
  value = keycloak_group.keycloak_read_admin_group.id
}

//This module create a read-admin-group in the master realm with the read roles for a specific other realm via the other-realm-client
//it outputs the group id , you can make users member of this group
//example:
// module "keycloak_realm_read_group" {
//   source      = "../modules/keycloak_realm_read_group"
//   master_realm_id = keycloak_realm.master.id
//   client_other_realm_id = "my-otherrealm-realm"
// }

//use group id in keycloak_group_memberships
// resource "keycloak_group_memberships" "my_members" {
//   realm_id = keycloak_realm.master.id
//   group_id = module.keycloak_realm_read_group.group_id

//   members = []
// }
