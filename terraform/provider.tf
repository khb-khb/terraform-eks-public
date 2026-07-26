terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"

      configuration_aliases = [
        aws.oregon,
        aws.virginia
      ]
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
  alias  = "oregon"
}

provider "aws" {
  region = "us-east-1"
  alias  = "virginia"
}

# 클러스터 추가 시 helm, kubernetes provider 추가
provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint["managed"]
    cluster_ca_certificate = base64decode(module.eks.cluster_ca["managed"])

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"

      command = "aws"

      args = [
        "eks",
        "get-token",
        "--cluster-name",
        module.eks.cluster_name["managed"],
        "--region",
        "us-west-2"
      ]
    }
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint["managed"]
  cluster_ca_certificate = base64decode(module.eks.cluster_ca["managed"])

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"

    args = [
      "eks",
      "get-token",
      "--cluster-name",
      module.eks.cluster_name["managed"],
      "--region",
      "us-west-2"
    ]
  }
}

provider "kubectl" {
  host                   = module.eks.cluster_endpoint["managed"]
  cluster_ca_certificate = base64decode(module.eks.cluster_ca["managed"])
  load_config_file       = false

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"

    args = [
      "eks",
      "get-token",
      "--cluster-name",
      module.eks.cluster_name["managed"],
      "--region",
      "us-west-2"
    ]
  }
}
