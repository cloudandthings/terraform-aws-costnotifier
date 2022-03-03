terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.49.0"
    }
  }
}

provider "aws" {
  alias   = "reference"
  region  = var.region
  profile = "pattern_demo"
}

provider "aws" {
  region  = var.region
  profile = "pattern_demo"

  default_tags {
    tags = local.mandatory_tags
  }
}