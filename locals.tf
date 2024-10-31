data "aws_availability_zones" "available" {}

locals {
  aws_resource_prefix = "${var.environment}-lab"

  azs = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Environment = var.environment
    Terraform   = true
    Owner       = "Evandro Gervasio Aguiar"
  }
}