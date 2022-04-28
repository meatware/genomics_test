output "iam_exif_s3_rwa_id" {
  description = "user A RW IAM access id"
  sensitive   = true
  value       = module.iam_exif_users.iam_exif_s3_rwa_id
}

output "iam_exif_s3_rwa_secret" {
  description = "user A RW IAM access secret"
  sensitive   = true
  value       = module.iam_exif_users.iam_exif_s3_rwa_secret
}
#
output "iam_exif_s3_rob_id" {
  description = "user B RO IAM access id"
  sensitive   = true
  value       = module.iam_exif_users.iam_exif_s3_rob_id
}

output "iam_exif_s3_rob_secret" {
  description = "user B RO IAM access secret"
  sensitive   = true
  value       = module.iam_exif_users.iam_exif_s3_rob_secret
}