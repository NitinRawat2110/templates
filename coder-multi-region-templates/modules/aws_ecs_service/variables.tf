# ECS Cluster ARNs by environment and region
variable "ecs_cluster" {
  description = "Input the ECS cluster ARN to host the workspace"
  type        = map(map(string))  # Map of environments, each containing a map of regions and their corresponding ARNs
  default = {
    "dev" = {
      "us-west-2" = "arn:aws:ecs:us-west-2:891499080000:cluster/coder-ecs-cluster"
      "ap-south-1" = "arn:aws:ecs:ap-south-1:891499080000:cluster/coder-ecs-cluster"
    },
    "prod" = {
      "us-west-2" = "arn:aws:ecs:us-west-2:670182930789:cluster/coder-ecs-cluster"
      "ap-south-1" = "arn:aws:ecs:ap-south-1:670182930789:cluster/coder-ecs-cluster"
    }
  }
}

# Define subnets for each region and environment
variable "ecs_subnets" {
  type        = map(map(list(string)))  # Map of environments, each containing a map of regions and their corresponding subnets
  default = {
    "dev" = {
      "us-west-2" = ["subnet-04a8b462dbcc88836", "subnet-02d232509bc800512", "subnet-0a7cb3d63efb31489"],
      "ap-south-1" = ["subnet-09e6f9e616d4b345", "subnet-04f085c3bdcaadf45", "subnet-0b8f091b3e37f3456"]
    },
    "prod" = {
      "us-west-2" = ["subnet-01d08891446a6089", "subnet-0c224d0fdfffbc789", "subnet-02e4377b239c3d7879"],
      "ap-south-1" = ["subnet-08441fcee25a14490", "subnet-00dfcc35758ca867g", "subnet-0313c051307cd8n54"]
    }
  }
}

variable "task_definition_arn" {
  description = "The ARN of the ECS task definition"
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

variable "start_count" {
  description = "The desired number of tasks to run"
  type        = number
}
