# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
  variable "path_relative_to_include" {
    description = "current path"
    default     = "fab-upg-sso/realm"
  }

  variable "path_relative_from_include" {
    description = "relative path"
    default     = "../.."
  }

  variable "output_fab-iam-debug-client_id" {
    description = "client_id of the child client on the parent realm (upg-sso)"
    default="dummy"
  }

  variable "project" {
    description = "project name"
    default     = "up"
  }

  variable "subproject" {
    description = "subproject name"
    default     = "idp"
  }

  variable "env" {
    description = "environment"
  }

  variable "keycloak_url" {
    description = "keycloak url"
  }

  variable "keycloak_client_id" {
    description = "keycloak client id"
    default     = "admin-cli"
  }

  variable "keycloak_user" {
    description = "keycloak user"
    default     = "admin"
  }

  variable "keycloak_password" {
    description = "keycloak user password"
  }
