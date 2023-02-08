resource "aws_iam_role" "EKSClusterRole" {
  name = "EKSClusterRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.5.1"
	enable_irsa     = true
  cluster_name    = var.eks_cluster_name
  cluster_version = "1.24"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  cluster_endpoint_public_access = true
  eks_managed_node_group_defaults = { ami_type = "AL2_x86_64" }
  eks_managed_node_groups = {
    one = {
      name = "node-group-1"
      instance_types = ["t3.small"]
      min_size     = 1
      max_size     = 3
      desired_size = 2
    }
  }
}

resource "aws_eks_addon" "addons" {
  for_each          = { for addon in var.eks_addons : addon.name => addon }
  cluster_name      = module.eks.cluster_name
  addon_name        = each.value.name
  addon_version     = each.value.version
  resolve_conflicts = "OVERWRITE"
}

module "vpc" {
  source            = "terraform-aws-modules/vpc/aws"
  version           = "3.19.0"
  name              = "eks-prod-vpc"
  cidr              = "10.0.0.0/16"
  azs               = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets   = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                        = 1
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"               = 1
  }
}

module "eks_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name             = "eks_node_role"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true
  attach_ebs_csi_policy = true
  attach_load_balancer_controller_policy = true
  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }
  tags = {
    Environment = "prod"
    Terraform   = "true"
  }
}

resource "aws_iam_role" "aws-load-balancer-controller" {
  name               = "aws-load-balancer-controller"
  description        = "for AWS Load Balancer Controller"
  assume_role_policy = templatefile(
    "./policy/aws-load-balancer-controller.json",
    {
      oidc_provider     = module.eks.oidc_provider
      oidc_provider_arn = module.eks.oidc_provider_arn
    }
  )
}

resource "aws_iam_role_policy_attachment" "aws-load-balancer-controller" {
  policy_arn = "${aws_iam_policy.albcontroller_policy.arn}"
  role       = "${aws_iam_role.aws-load-balancer-controller.name}"
}
