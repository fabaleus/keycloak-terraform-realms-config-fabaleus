# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  backend "s3" {
    access_key                  = "mock_access_key"
    bucket                      = "terraform-state"
    encrypt                     = true
    endpoint                    = "http://localstack.aws.prod.fabaleus.com:4566"
    force_path_style            = true
    key                         = "fab-upg-sso/realm/terraform.tfstate"
    region                      = "us-east-1"
    secret_key                  = "mock_secret_key"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }
}
