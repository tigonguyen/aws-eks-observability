locals {
  env_vars = yamldecode(file("${path.module}/env_vars.yaml"))

  tags = {
    Env        = "${terraform.workspace}"
    Author     = "tigonguyen"
    GithubRepo = "tigonguyen/aws-eks-production-ready-observability"
  }
}