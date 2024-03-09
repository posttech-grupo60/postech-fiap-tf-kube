terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.38"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

data "aws_eks_cluster" "default" {
  name = var.cluster_name
  depends_on = [ module.eks ]
}

data "aws_eks_cluster_auth" "default" {
  name = var.cluster_name
  depends_on = [ module.eks ]
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.default.token
}