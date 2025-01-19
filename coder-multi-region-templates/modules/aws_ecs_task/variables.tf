variable "execution_role_arn" {
  description = "The ARN of the execution role for the ECS task."
  type        = string
  default     = "arn:aws:iam::891499080000:role/coder-multi-region-cft-CoderMultiRegionCoderAppExec"
}

variable "task_role_arn" {
  description = "The ARN of the task role for the ECS task."
  type        = string
  default     = "arn:aws:iam::891499080000:role/coder-multi-region-cft-CoderMultiRegionWorkspaceTas"
}

variable "cpu" {
  description = "The CPU units to allocate to the task"
  type        = number
}

variable "memory" {
  description = "The memory (in MiB) to allocate to the task"
  type        = number
}

variable "file_system_id" {
  description = "The ID of the EFS file system"
}

variable "access_point_id" {
  description = "The ID of the EFS access point"
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

variable "coder_agent_token" {
  description = "The token for the coder agent"
  type        = string
  sensitive   = true
}

variable "coder_agent_init_script" {
  description = "The initialization script for the coder agent"
  type        = string
}

variable "include_mariadb_container"{
  description = "The value of mariadb container"
}

variable "include_mongodb_container"{
  description = "The value of mongodb container"
}

variable "include_localstack_container"{
  description = "The value of localstack container"
}
