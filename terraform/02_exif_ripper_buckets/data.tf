resource "aws_ssm_parameter" "bucket_source" {
  name  = "${var.ssm_root_path}/bucket_source"
  type  = "String"
  value = var.bucket_source
}

resource "aws_ssm_parameter" "bucket_dest" {
  name  = "${var.ssm_root_path}/bucket_dest"
  type  = "String"
  value = var.bucket_dest
}