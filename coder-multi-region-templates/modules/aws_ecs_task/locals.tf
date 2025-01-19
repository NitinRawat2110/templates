locals {
  regions = ["us-west-2", "ap-south-1"]
  environments = ["dev", "prod"]

  containers = [
    {
      name  = "CDD Build Workspace"
      image = "229688178.dkr.ecr.us-west-2.amazonaws.com/devops:coder-base-ubuntu"
    },
    {
      name  = "Golang Container-based workspace"
      image = "229688178.dkr.ecr.us-west-2.amazonaws.com/devops:golang-ubuntu-22.04"
    },
    {
      name  = "ScmDb Node 18 Container-EC2 based workspace"
      image = "229688178.dkr.ecr.us-west-2.amazonaws.com/corpit-scmdb:mariadb-docker-template-latest"
    },
    {
      name  = "ScmDb Node 18 Container-based workspace"
      image = "229688178.dkr.ecr.us-west-2.amazonaws.com/devops:node-18-buster"
    },
    {
      name  = "ScmDb Python 3.8 Container-EC2-based workspace"
      image = "229688178.dkr.ecr.us-west-2.amazonaws.com/devops:scmdb-py-ubuntu-22.04"
    },
    {
      name  = "Python 3.8 Container-based workspace"
      image = "229688178.dkr.ecr.us-west-2.amazonaws.com/devops:scmdb-py-ubuntu-22.04"
    },
    {
      name  = "Simple container-based workspace"
      image = "229688178.dkr.ecr.us-west-2.amazonaws.com/devops:coder-base-ubuntu"
    },
    {
      name  = "Python 3.8 Container-based workspace"
      image = "229688178.dkr.ecr.us-west-2.amazonaws.com/devops:x64-next"
    }
  ]

  # Creating container definitions for each region and environment combination
  workspace_container_definitions = flatten([
    for region in local.regions : [
      for environment in local.environments : [
        for container in local.containers : {
          name      = "coder-workspace-${var.coder_workspace_id}"
          image     = container.image
          essential = true
          user      = "coder"
          command   = ["sh", "-c", var.coder_agent_init_script]
          environment = [
            {
              "name"  = "CODER_AGENT_TOKEN"
              "value" = var.coder_agent_token
            }
          ]
          mountPoints = [
            {
              sourceVolume  = "home-dir-${var.coder_workspace_id}"
              containerPath = "/home/coder"
            }
          ]
          portMappings = [
            {
              containerPort = 80
              hostPort      = 80
            }
          ]
        }
      ]
    ]
  ])

  mariadb_container_definition = {
    name      = "mariadb-service-${var.coder_workspace_id}"
    image     = "229688178.dkr.ecr.us-west-2.amazonaws.com/corpit-scmdb:mariadb-docker-template-latest"
    essential = false
    environment = [
      {
        name  = "MYSQL_ROOT_PASSWORD"
        value = "root"
      }
    ]
    portMappings = [
      {
        containerPort = 3306
        hostPort      = 3306
      }
    ]
  }

  mongodb_container_definition = {
    name  = "mongodb-service-${var.coder_workspace_id}"
    image = "229688178.dkr.ecr.us-west-2.amazonaws.com/devops:mongo-4.2"
    essential = false
    portMappings = [
      {
        containerPort = 27017
        hostPort      = 27017
      }
    ]
  }

  localstack_container_definition = {
    name      = "localstack-service-${var.coder_workspace_id}"
    image     = "229688178.dkr.ecr.us-west-2.amazonaws.com/devops:localstack"
    essential = false
    environment = [
      {
        name  = "SERVICES"
        value = "s3"
      }
    ]
    portMappings = [
      {
        containerPort = 4566
        hostPort      = 4566
      },
      {
        containerPort = 4571
        hostPort      = 4571
      }
    ]
  }

  # Combine all container definitions, including optional ones like mariadb, mongodb, localstack
  task_container_definitions = concat(
    local.workspace_container_definitions,
    (var.include_mariadb_container ? [local.mariadb_container_definition] : []),
    (var.coder_parameter.include_mongodb_container ? [local.mongodb_container_definition] : []),
    (var.coder_parameter.include_localstack_container ? [local.localstack_container_definition] : [])
  )
}
