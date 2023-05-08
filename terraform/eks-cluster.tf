module "eks_cluster" {
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
    provider_key_arn = aws_kms_key.eks_kms_key.arn
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