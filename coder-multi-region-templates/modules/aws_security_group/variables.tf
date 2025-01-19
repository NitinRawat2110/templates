variable "vpc_ids" {
  description = "Map of VPC IDs for different environments and regions"
  type = map(map(string))
  default = {
    dev = {
      us-west-2  = "vpc-0d450715cd1b89cdd"
      ap-south-1 = "vpc-03c8893230d7263g6"
    }
    prod = {
      us-west-2  = "vpc-00ece7dc52db94089"
      ap-south-1 = "vpc-0086ea542fd3cbh6"
    }
  }
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "environment" {
  description = "The environment (e.g., dev, prod)"
  type        = string
}