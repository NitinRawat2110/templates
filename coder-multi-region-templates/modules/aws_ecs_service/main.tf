# Use the local variable in the resource
resource "aws_ecs_service" "workspace" {
  for_each        = { for idx, value in local.flattened_subnets : "${value.env}-${value.region}-${idx}" => value }

  name            = "workspace-${var.coder_workspace_id}"
  cluster         = var.ecs_cluster[each.value.env][each.value.region]  # Access the cluster ARN for the specific environment and region
  task_definition = var.task_definition_arn
  desired_count   = var.start_count

  # Network configuration with subnets based on each environment and region
  network_configuration {
    assign_public_ip = false
    subnets          = [each.value.subnet]  # Pass the subnet dynamically based on the environment and region
  }
}