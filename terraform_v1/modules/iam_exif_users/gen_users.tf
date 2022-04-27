locals {
  all_users = toset(concat(var.ro_user_list, var.rw_user_list))
}

resource "aws_iam_user" "exif_s3" {

  for_each = length(local.all_users) > 0 ? local.all_users : []

  name = each.value
  path = "/users/exifripper/${var.env}/"


  tags = var.tags
}

