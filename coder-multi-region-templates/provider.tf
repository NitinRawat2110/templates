terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
      version = "~> 0.7.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.55"
    }
  }
}

provider "coder" {
}

# configure AWS provider with creds present on Coder server host
provider "aws" {
  alias                   = "us_west_2"
  region                  = "us-west-2"
  shared_config_files     = ["$HOME/.aws/config"]
  shared_credentials_files = ["$HOME/.aws/credentials"]
}

provider "aws" {
  alias                   = "ap_south_1"
  region                  = "ap-south-1"
  shared_config_files     = ["$HOME/.aws/config"]
  shared_credentials_files = ["$HOME/.aws/credentials"]
}
