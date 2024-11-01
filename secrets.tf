module "secrets_manager_rds" {
  source  = "terraform-aws-modules/secrets-manager/aws"
  version = "~> 1.3"

  name_prefix = "${local.aws_resource_prefix}-rds-password"
  description = "Secret RDS Password"

  create_random_password = true
  random_password_length = 40
}