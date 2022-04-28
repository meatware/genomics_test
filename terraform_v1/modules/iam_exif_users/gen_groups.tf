# resource "aws_iam_group" "exifripper_s3_ro" {
#   name = "exifripper_s3_ro"
#   path = "/users/apps/"
# }

# resource "aws_iam_group" "exifripper_s3_rw" {
#   name = "exifripper_s3_rw"
#   path = "/users/apps/"
# }


# # locals {

# #     ro_users = {
# #         for key, value in var.user_maps :
# #         key => {
# #             user_name = var.user_maps[key].user_name
# #         }
# #      }


# # }


# resource "aws_iam_group_membership" "exifripper_s3_ro" {

#   #for_each = length(var.user_maps) > 0 ? var.user_maps : {}

#   name = "exifripper-s3-ro-group-membership"

#   users = var.ro_user_list

#   group = aws_iam_group.exifripper_s3_ro.name
# }

# # output "ro_users" {
# #     value = local.ro_users
# # }
