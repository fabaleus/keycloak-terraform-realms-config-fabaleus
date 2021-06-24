# stage/terragrunt.hcl

remote_state {
  backend = "s3"
  generate = {
    path      = "tr_backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    encrypt = true
    bucket = "terraform-state"
    key = "${path_relative_to_include()}/terraform.tfstate"
    region = "us-east-1"
    endpoint = "http://localstack.aws.prod.fabaleus.com:4566"
    access_key = "mock_access_key"
    secret_key = "mock_secret_key"
    skip_credentials_validation = true
    skip_metadata_api_check = true
    force_path_style = true
  }
}
generate "tr_main" {
  path = "tr_main.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
  terraform {
    required_version = ">= 0.14"

    required_providers {
      keycloak = {
        source  = "mrparkers/keycloak"
        version = ">= 2.3.0"
      }
      aws = {
        source  = "hashicorp/aws"
        version = ">= 2.70"
      }
    }
  }

  provider "keycloak" {
    username  = var.keycloak_user
    password  = var.keycloak_password
    client_id = var.keycloak_client_id
    url       = var.keycloak_url
  }

provider "aws" {
    access_key                  = "mock_access_key"
    region                      = "us-east-1"
    s3_force_path_style         = true
    secret_key                  = "mock_secret_key"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true

    endpoints {
      secretsmanager = "http://localstack.aws.prod.fabaleus.com:4566"
      s3             = "http://localstack.aws.prod.fabaleus.com:4566"
    }
  }
EOF
}

generate "variables" {
  path = "tr_variables.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
  variable "path_relative_to_include" {
    description = "current path"
    default     = "${path_relative_to_include()}"
  }

  variable "path_relative_from_include" {
    description = "relative path"
    default     = "${path_relative_from_include()}"
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
EOF
}
