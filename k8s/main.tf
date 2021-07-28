#------------------
#terraform
#------------------
terraform {
  required_version = ">=0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.51.0"
    }
  }
}
#------------------
#provider
#------------------
provider "aws" {
  profile = "default"
  region  = "ap-northeast-1"
}

#------------------
#varibales
#------------------
variable "k8s" {
  type    = string
  default = "kubernetes.io/cluster/k8s"
}
variable "project" {
  type    = string
  default = "terraform"
}
