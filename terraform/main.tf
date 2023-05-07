module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_name                    = "${terraform.workspace}-${local.env_vars.clusterName}"
  cluster_version                 = local.env_vars.clusterVersion
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    # Check README.md References for Update CoreDNS
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  cluster_encryption_config = [{
    provider_key_arn = aws_kms_key.eks.arn
    resources        = ["secrets"]
  }]

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # You require a node group to schedule coredns which is critical for running correctly internal DNS.
  # If you want to use only fargate you must follow docs `(Optional) Update CoreDNS`
  # available under https://docs.aws.amazon.com/eks/latest/userguide/fargate-getting-started.html
  eks_managed_node_groups = {
    example = {
      desired_size = 1

      instance_types = ["t3.small"]
      labels = {
        Example    = "managed_node_groups"
        GithubRepo = "terraform-aws-eks"
        GithubOrg  = "terraform-aws-modules"
      }
      tags = {
        ExtraTag = "example"
      }
    }
  }

  fargate_profiles = {
    default = {
      name = "default"
      selectors = [
        {
          namespace = "default"
        }
      ]
      tags = {
        Owner = "default"
      }
      timeouts = {
        create = "20m"
        delete = "20m"
      }
    }
    apps = {
      name = "apps"
      selectors = [
        {
          namespace = "apps"
          labels = {
            Application = "backendapi"
          }
        },
        {
          namespace = "apps"
          labels = {
            Application = "database"
          }
        },
      ]
      tags = {
        Owner = "apps"
      }
      timeouts = {
        create = "20m"
        delete = "20m"
      }
    }
    monitoring = {
      name = "monitoring"
      selectors = [
        {
          namespace = "monitoring"
        }
      ]
      tags = {
        Owner = "monitoring"
      }
      timeouts = {
        create = "20m"
        delete = "20m"
      }
    }
  }

  tags = local.tags
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "${terraform.workspace}-${local.env_vars.vpcName}"
  cidr = local.env_vars.vpcCIDR

  azs = ["${local.env_vars.region}a", "${local.env_vars.region}b", "${local.env_vars.region}c"]
  # The subnets must use IP address based naming
  private_subnets = local.env_vars.privateSubnets
  public_subnets  = local.env_vars.publicSubnets # for inbound access from the internet to your pods

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  enable_flow_log                      = true
  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true

  # Check README.md References for VPC and subnet requirements
  public_subnet_tags = {
    "kubernetes.io/cluster/${terraform.workspace}-${local.env_vars.vpcName}" = "shared"
    "kubernetes.io/role/elb"                                                 = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${terraform.workspace}-${local.env_vars.vpcName}" = "shared"
    "kubernetes.io/role/internal-elb"                                        = 1
  }

  tags = local.tags
}

resource "aws_kms_key" "eks" {
  description             = "EKS Secret Encryption Key"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = local.tags
}