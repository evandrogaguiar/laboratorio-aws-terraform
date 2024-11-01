data "aws_availability_zones" "available" {}

locals {
  aws_resource_prefix = "${var.environment}-lab"

  azs = slice(data.aws_availability_zones.available.names, 0, 3)

  engine               = "mysql"
  engine_version       = "8.0"
  family               = "mysql8.0"
  major_engine_version = "8.0"
  port                 = 3306

  tags = {
    Environment = var.environment
    Terraform   = true
    Owner       = "Evandro Gervasio Aguiar"
  }
}