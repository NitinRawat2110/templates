variable "subnets" {
  description = "Map of subnets by environment and region"
  type = map(map(list(string)))
  default = {
    "dev" = {
      "us-west-2" = [
        "subnet-0b9f2c510103e1912",  # Dev Subnet 1 in us-west-2
        "subnet-0936c16e6273050bb",  # Dev Subnet 2 in us-west-2
        "subnet-094efc0a38e4152aa"   # Dev Subnet 3 in us-west-2
      ],
      "ap-south-1" = [
        "subnet-02b1bbb14ed0f6348",  # Dev Subnet 1 in ap-south-1
        "subnet-0b3cce8ad5c243345",   # Dev Subnet 2 in ap-south-1
        "subnet-0d40ec53021613234"     # Dev Subnet 3 in ap-south-1
      ]
    },
    "prod" = {
      "us-west-2" = [
        "subnet-0e2032115b5a91678",  # Prod Subnet 1 in us-west-2
        "subnet-0137ef08224db4029",  # Prod Subnet 2 in us-west-2
        "subnet-06ca9f5fbd916b243"   # Prod Subnet 3 in us-west-2
      ],
      "ap-south-1" = [
        "subnet-033e9eca30157524v",  # Prod Subnet 1 in ap-south-1
        "subnet-0164643bffb7efv56",  # Prod Subnet 2 in ap-south-1
        "subnet-05c8ddc480bfa745t"   # Prod Subnet 3 in ap-south-1
      ]
    }
  }
}

variable "security_group_ids" {
  description = "Map of security group IDs"
  type        = map(string)
}


variable "region" {
  description = "AWS Region"
  type        = string
}

variable "environment" {
  description = "The environment (e.g., dev, prod)"
  type        = string
}

variable "coder_workspace_id" {
  description = "ID of the Coder workspace"
  type        = string
}