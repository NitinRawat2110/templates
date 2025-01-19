resource "aws_efs_file_system" "workspace_storage" {
  encrypted        = true
  performance_mode = "generalPurpose"
  throughput_mode  = "elastic"
}

resource "aws_efs_mount_target" "workspace_storage_mt" {
  for_each = { for idx, subnet in local.flattened_subnets : "${subnet.env}_${subnet.region}_${subnet.index}" => subnet }
  file_system_id  = aws_efs_file_system.workspace_storage.id
  subnet_id       = each.value.subnet
  security_groups = [var.security_group_ids["${each.value.env}-${each.value.region}"]]
}

resource "aws_efs_access_point" "workspace_storage_ap" {
  file_system_id = aws_efs_file_system.workspace_storage.id

  root_directory {
    path = "/${var.coder_workspace_id}"
    # Use the local-exec provisioner to run a shell script to check the UID and GID

    # Read the generated UID and GID from the file
    creation_info {
      owner_uid = file("${path.module}/check_uid_gid.sh") == "1000 1000" ? 1000 : 1001
      owner_gid = file("${path.module}/check_uid_gid.sh") == "1000 1000" ? 1000 : 1001
      permissions = "0755"
    }
  }
}
