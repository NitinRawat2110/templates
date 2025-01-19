module "aws_security_group" {
  source   = "./modules/aws_security_group"
  region     = var.region
  environment = var.environment
}

module "aws_efs_service" {
  source   = "./modules/aws_efs_service"
  security_group_ids = module.aws_security_group.security_group_id
  coder_workspace_id = data.coder_workspace.me.id
  region     = var.region
  environment = var.environment
}

module "aws_ecs_task" {
  source   = "./modules/aws_ecs_task"
  cpu      = data.coder_parameter.cpu.value
  memory   = data.coder_parameter.memory.value
  file_system_id  = module.aws_efs_service.file_system_id
  access_point_id = module.aws_efs_service.access_point_id
  coder_workspace_id = data.coder_workspace.me.id
  coder_agent_token        = output.coder_agent_token
  coder_agent_init_script  = output.coder_agent_init_script
  region     = var.region
  environment = var.environment
}

module "aws_ecs_service" {
  for_each = module.aws_ecs_task 
  source   = "./modules/aws_ecs_service"
  task_definition_arn = each.value.task_definition_arn
  coder_workspace_id = data.coder_workspace.me.id
  start_count = data.coder_workspace.me.start_count
  region     = var.region
  environment = var.environment
}

data "coder_parameter" "cpu" {
  name         = "cpu"
  display_name = "CPU"
  description  = "The number of CPU units to reserve for the container"
  type         = "number"
  default      = "1024"
  mutable      = true
}

data "coder_parameter" "memory" {
  name         = "memory"
  display_name = "Memory"
  description  = "The amount of memory (in MiB) to allow the container to use"
  type         = "number"
  default      = "4096"
  mutable      = true
}

data "coder_parameter" "include_mariadb_container" {
  name         = "include_mariadb_container"
  display_name = "Include MariaDB Container"
  description  = "Include a container with the mariadb_docker_template for test purposes"
  type         = "bool"
  default      = false
  mutable      = true
}

data "coder_parameter" "include_mongodb_container" {
  name         = "include_mongodb_container"
  display_name = "Include MongoDB Container"
  description  = "Include a container with mongodb for test purposes"
  type         = "bool"
  default      = false
  mutable      = true
}

data "coder_parameter" "include_localstack_container" {
  name         = "include_localstack_container"
  display_name = "Include localstack Container"
  description  = "Include a container with localstack for test purposes"
  type         = "bool"
  default      = false
  mutable      = true
}

data "coder_workspace" "me" {}

resource "coder_agent" "coder" {
  arch                   = "amd64"
  auth                   = "token"
  os                     = "linux"
  dir                    = "/home/coder"
  # startup_script_timeout = 180
  startup_script         = <<-EOT
    set -e

    # add git.com to ssh known hosts
    mkdir -p ~/.ssh
    ssh-keygen -F git.com || ssh-keyscan -H git.com >> ~/.ssh/known_hosts

    # install and start code-server
    curl -fsSL https://code-server.dev/install.sh | sh -s -- --method=standalone --prefix=/tmp/code-server --version 4.11.0
    /tmp/code-server/bin/code-server --auth none --port 13337 >/tmp/code-server.log 2>&1 &
  EOT
}


resource "coder_app" "code-server" {
  agent_id     = coder_agent.coder.id
  slug         = "code-server"
  display_name = "code-server"
  icon         = "/icon/code.svg"
  url          = "http://localhost:13337?folder=/home/coder"
  subdomain    = false
  share        = "owner"

  healthcheck {
    url       = "http://localhost:13337/healthz"
    interval  = 3
    threshold = 10
  }
}

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
