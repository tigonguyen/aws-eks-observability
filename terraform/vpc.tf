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