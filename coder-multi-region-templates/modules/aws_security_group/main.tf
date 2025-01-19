resource "aws_security_group" "workspace_storage_sg" {
  for_each = { for vpc in local.flattened_vpc_ids : vpc.key => vpc.vpc_id }

  description = "efs sg"
  vpc_id      = each.value
  

  ingress {
    description = "efs"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["100.64.8.0/21"]
  }

  egress {
    description = "all outbound allowed"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
