module "smtp-server-auth-password" {
  source      = "../../modules/aws_secretsmanager_secret_value"
  secret_path = "/${var.project}/${var.subproject}/${var.env}/containers/keycloak/config/smtp-server-auth-password"
}
