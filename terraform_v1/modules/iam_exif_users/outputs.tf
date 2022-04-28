output "iam_exif_s3_rwa_id" {
  sensitive = true
  value = aws_iam_access_key.exif_s3_rwa.id
}

output "iam_exif_s3_rwa_secret" {
  sensitive = true
  value = aws_iam_access_key.exif_s3_rwa.secret
}
#
output "iam_exif_s3_rob_id" {
  sensitive = true
  value = aws_iam_access_key.exif_s3_rob.id
}

output "iam_exif_s3_rob_secret" {
  sensitive = true
  value = aws_iam_access_key.exif_s3_rob.secret
}