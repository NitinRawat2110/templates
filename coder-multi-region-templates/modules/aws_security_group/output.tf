output "security_group_id" {
  value = { for key, sg in aws_security_group.workspace_storage_sg : key => sg.id }
}
