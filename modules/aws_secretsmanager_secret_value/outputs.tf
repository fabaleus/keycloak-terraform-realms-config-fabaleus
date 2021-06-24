output "secret_value" {
  value = data.aws_secretsmanager_secret_version.secret_version.secret_string
}