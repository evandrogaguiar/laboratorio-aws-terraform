module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${local.aws_resource_prefix}-${data.aws_region.current.name}"
  cluster_version = "1.30"

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent              = true
      service_account_role_arn = module.vpc_cni_irsa.iam_role_arn
    }
    aws-ebs-csi-driver = {
      most_recent              = true
      service_account_role_arn = module.ebs_csi_irsa.iam_role_arn
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  cluster_security_group_additional_rules = merge({
    ingress_self_all = {
      description = "Node to node all ports/protocol"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }

    ingress_cluster_all = {
      description                   = "Node to node all ports/protocols"
      protocol                      = "-1"
      from_port                     = 0
      to_port                       = 0
      type                          = "ingress"
      self                          = true
      source_cluster_security_group = true
    }
  })

  eks_managed_node_group_defaults = {
    disk_size                  = 80
    iam_role_attach_cni_policy = true

    block_device_mappings = {
      xvda = {
        device_name = "/dev/xvda"
        ebs = {
          volume_size           = 80
          volume_type           = "gp2"
          delete_on_termination = true
        }
      }
    }
  }

  eks_managed_node_groups = merge(
    {
      on_demand = {
        name            = "${local.aws_resource_prefix}-ondemand-worker"
        description     = "EKS ${local.aws_resource_prefix} managed on demand node group launch template"
        use_name_prefix = true

        subnet_ids = module.vpc.private_subnets

        min_size     = var.environment == "prod" ? 6 : 2
        desired_size = var.environment == "prod" ? 8 : 2
        max_size     = var.environment == "prod" ? 10 : 3

        instance_types = ["m5.xlarge"]

        capacity_type        = "ON_DEMAND"
        disk_size            = 80
        force_update_version = true
        ebs_optimized        = true

        create_iam_role          = true
        iam_role_name            = "${local.aws_resource_prefix}-ondemand-role"
        iam_role_use_name_prefix = false
        iam_role_description     = "EKS ${local.aws_resource_prefix} managed on demand node group role"

        tags = {
          Terraform = "true"
          Contract  = "ON_DEMAND"
        }
      }
    },
    var.environment == "prod" ? {} : {
      spot = {
        name            = "${local.aws_resource_prefix}-spot-worker"
        description     = "EKS ${local.aws_resource_prefix} managed spot node group launch template"
        use_name_prefix = true

        subnet_ids = module.vpc.private_subnets

        min_size     = 2
        desired_size = 2
        max_size     = 3

        instance_types = ["m5.large"]

        capacity_type        = "SPOT"
        disk_size            = 80
        force_update_version = true
        ebs_optimized        = true

        create_iam_role          = true
        iam_role_name            = "${local.aws_resource_prefix}-spot-role"
        iam_role_use_name_prefix = false
        iam_role_description     = "EKS ${local.aws_resource_prefix} managed spot node group role"

        tags = {
          Terraform = "true"
          Contract  = "SPOT"
        }
      }
    }
  )
}

module "lb_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                              = "${local.aws_resource_prefix}-eks-lb-rsa"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

module "vpc_cni_irsa" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name_prefix      = "${local.aws_resource_prefix}-vpc-cni-rsa"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:vpc-cni-controller"]
    }
  }
}

module "ebs_csi_irsa" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "${local.aws_resource_prefix}-ebs-csi-rsa"
  attach_ebs_csi_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-rsa"]
    }
  }
}

resource "helm_release" "alb-controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  values = [yamlencode(
    {
      clusterName = module.eks.cluster_name
      serviceAccount = {
        create = true
        name   = "aws-load-balancer-controller"
        annotations = {
          "eks.amazonaws.com/role-arn" = module.lb_role.iam_role_arn
        }
        labels = {
          "app.kubernetes.io/name"      = "aws-load-balancer-controller"
          "app.kubernetes.io/component" = "controller"
        }
      }
    }
  )]
}

#Instalação Metrics Server

data "http" "metrics_server" {
  url = "https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml"
}

resource "kubectl_manifest" "metrics_server" {
  depends_on = [module.eks]
  yaml_body  = data.http.metrics_server.response_body
}
