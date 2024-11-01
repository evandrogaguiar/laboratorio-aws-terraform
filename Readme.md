## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.62 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.74.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_rds-master"></a> [rds-master](#module\_rds-master) | terraform-aws-modules/rds/aws | ~> 6.10 |
| <a name="module_rds-replica"></a> [rds-replica](#module\_rds-replica) | terraform-aws-modules/rds/aws | ~> 6.10 |
| <a name="module_secrets_manager_rds"></a> [secrets\_manager\_rds](#module\_secrets\_manager\_rds) | terraform-aws-modules/secrets-manager/aws | ~> 1.3 |
| <a name="module_security-group-rds"></a> [security-group-rds](#module\_security-group-rds) | terraform-aws-modules/security-group/aws | ~> 5.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Resources environment name. Default to 'prod' | `string` | `"prod"` | no |
| <a name="input_profile"></a> [profile](#input\_profile) | n/a | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region to deploy resources. Default to 'sa-east-1' | `string` | `"sa-east-1"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | The IPv4 block used for main CIDR on VPC and subnets | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_database_subnet_group_name"></a> [database\_subnet\_group\_name](#output\_database\_subnet\_group\_name) | Name of database subnet group |
| <a name="output_database_subnets"></a> [database\_subnets](#output\_database\_subnets) | List of IDs of database subnets |
| <a name="output_database_subnets_cidr_blocks"></a> [database\_subnets\_cidr\_blocks](#output\_database\_subnets\_cidr\_blocks) | List of cidr\_blocks of database subnets |
| <a name="output_nat_public_ips"></a> [nat\_public\_ips](#output\_nat\_public\_ips) | List of public Elastic IPs created for AWS NAT Gateway |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | List of IDs of private subnets |
| <a name="output_private_subnets_cidr_blocks"></a> [private\_subnets\_cidr\_blocks](#output\_private\_subnets\_cidr\_blocks) | List of cidr\_blocks of private subnets |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | List of IDs of public subnets |
| <a name="output_public_subnets_cidr_blocks"></a> [public\_subnets\_cidr\_blocks](#output\_public\_subnets\_cidr\_blocks) | List of cidr\_blocks of public subnets |
| <a name="output_rds_master_db_instance_address"></a> [rds\_master\_db\_instance\_address](#output\_rds\_master\_db\_instance\_address) | The address of the RDS instance |
| <a name="output_rds_master_db_instance_endpoint"></a> [rds\_master\_db\_instance\_endpoint](#output\_rds\_master\_db\_instance\_endpoint) | The endpoint of the RDS instance |
| <a name="output_rds_master_db_instance_identifier"></a> [rds\_master\_db\_instance\_identifier](#output\_rds\_master\_db\_instance\_identifier) | The RDS identifier |
| <a name="output_security_group_name"></a> [security\_group\_name](#output\_security\_group\_name) | The name of the security group |
| <a name="output_vpc_arn"></a> [vpc\_arn](#output\_vpc\_arn) | The ARN of the VPC |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
