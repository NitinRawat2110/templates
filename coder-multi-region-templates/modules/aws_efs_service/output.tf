output "file_system_id" {
  description = "The ID of the EFS file system"
  value       = aws_efs_file_system.workspace_storage.id
}

output "access_point_id" {
  description = "The ID of the EFS access point"
  value       = aws_efs_access_point.workspace_storage_ap.id
}
