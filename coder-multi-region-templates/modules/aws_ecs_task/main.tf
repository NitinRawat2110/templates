resource "aws_ecs_task_definition" "workspace" {
  family = "coder"

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions    = jsonencode(local.task_container_definitions)

  # workspace persistent volume definition
  volume {
    name = "home-dir-${var.coder_workspace_id}"

    efs_volume_configuration {
      file_system_id = var.file_system_id
      root_directory = "/${var.coder_workspace_id}"
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = var.access_point_id
        iam             = "ENABLED"
      }
    }
  }
}
