output "iam_role_arn" {
  description = "Lambda IAM role arn used for serverless function"
  value       = module.lambda_role_and_policies.iam_role_arn
}

# output "ro_users" {
#     value = module.iam_exif_users.ro_users
# }

output "bucket_source_name" {
  description = "exif-ripper s3 source bucket name"
  value       = module.exif_buckets.bucket_source_name
}

output "bucket_dest_name" {
  description = "exif-ripper s3 destination bucket name"
  value       = module.exif_buckets.bucket_dest_name
}
output "iam_exif_s3_rwa_id" {
  sensitive = true
  value = module.iam_exif_users.iam_exif_s3_rwa_id
}

output "iam_exif_s3_rwa_secret" {
  sensitive = true
  value = module.iam_exif_users.iam_exif_s3_rwa_secret
}
#
output "iam_exif_s3_rob_id" {
  sensitive = true
  value = module.iam_exif_users.iam_exif_s3_rob_id
}

output "iam_exif_s3_rob_secret" {
  sensitive = true
  value = module.iam_exif_users.iam_exif_s3_rob_secret
}