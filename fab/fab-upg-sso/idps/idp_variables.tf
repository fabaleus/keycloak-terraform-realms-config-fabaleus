locals {
  realm_id = replace(var.path_relative_to_include, "/idps", "")
}
variable "fab_iam_debug_client_id" {
  type = string
  # This is passed in from terragrunt inputs attribute
}
