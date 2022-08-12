# ---- root/provider

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.25.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.3.2"
    }
  }
  required_version = ">= 0.13"
}

provider "aws" {
  region = "us-east-2"
}

provider "random" {}
