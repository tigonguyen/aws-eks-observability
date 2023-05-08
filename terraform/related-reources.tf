resource "aws_kms_key" "eks_kms_key" {
  description             = "EKS Secret Encryption Key"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = local.tags
}

# Create the ECR repository
resource "aws_ecr_repository" "private_ecr" {
  name = "k8s-obs-registry"
  image_tag_mutability = "MUTABLE"  # Optional: Adjust tag mutability based on your requirements
}