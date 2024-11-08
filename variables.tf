#General
variable "environment" {
  description = "Resources environment name. Default to 'prod'"
  default     = "prod"
  validation {
    condition     = contains(["prod", "dev"], var.environment)
    error_message = "The environment name must be one of the following: prod, dev."
  }
}

variable "region" {
  description = "AWS region to deploy resources. Default to 'sa-east-1'"
  default     = "sa-east-1"
}

#VPC
variable "vpc_cidr" {
  description = "The IPv4 block used for main CIDR on VPC and subnets"
}