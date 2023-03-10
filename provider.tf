provider "aws" {
  region = var.aws_region
}

provider "helm" {
  kubernetes {
    config_path = pathexpand(var.kube_config)
  }
}

provider "kubernetes" {
  config_path = pathexpand(var.kube_config)
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.9.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.4.1"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.1.2"
    }
  }
}