# locals {
#   all_users = toset(concat(var.ro_user_list, var.rw_user_list))
# }

resource "aws_iam_user" "exif_s3_rwa" {

  #for_each = length(local.all_users) > 0 ? local.all_users : []

  name = "user_a_rwa"
  path = "/users/exifripper/${var.env}/"

  tags = var.tags
}

resource "aws_iam_user" "exif_s3_rob" {

  #for_each = length(local.all_users) > 0 ? local.all_users : []

  name = "user_b_rob"
  path = "/users/exifripper/${var.env}/"

  tags = var.tags
}

######################################################
resource "aws_iam_access_key" "exif_s3_rwa" {
  user = aws_iam_user.exif_s3_rwa.name
}

resource "aws_iam_access_key" "exif_s3_rob" {
  user = aws_iam_user.exif_s3_rob.name
}


######################################################
resource "aws_iam_user_policy" "exif_s3_rwa" {

  name = "exif-ripper-source-bucket-rwa"
  user = aws_iam_user.exif_s3_rwa.name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket"
        ],
        "Resource" : "arn:aws:s3:::${var.bucket_source}"
      },
      {
        "Effect" : "Deny",
        "Action" : [
          "s3:ListBucket"
        ],
        "NotResource" : [
          "arn:aws:s3:::${var.bucket_source}",
          "arn:aws:s3:::${var.bucket_source}/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:PutObject",
          "s3:PutObjectAcl"
        ],
        "Resource" : [
          "arn:aws:s3:::${var.bucket_source}",
          "arn:aws:s3:::${var.bucket_source}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_user_policy" "exif_s3_rob" {

  name = "exif-ripper-source-bucket-rob"
  user = aws_iam_user.exif_s3_rob.name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket"
        ],
        "Resource" : "arn:aws:s3:::${var.bucket_dest}"
      },
      {
        "Effect" : "Deny",
        "Action" : [
          "s3:ListBucket"
        ],
        "NotResource" : [
          "arn:aws:s3:::${var.bucket_dest}",
          "arn:aws:s3:::${var.bucket_dest}/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:GetObject"
        ],
        "Resource" : [
          "arn:aws:s3:::${var.bucket_dest}",
          "arn:aws:s3:::${var.bucket_dest}/*"
        ]
      }
    ]
  })
}

# ######################################################
# resource "aws_iam_user_policy_attachment" "attach_rwa" {
#   user       = aws_iam_user.exif_s3_rwa.name
#   policy_arn = aws_iam_policy.exif_s3_rwa.arn
# }

# resource "aws_iam_user_policy_attachment" "attach_rob" {
#   user       = aws_iam_user.exif_s3_rob.name
#   policy_arn = aws_iam_policy.exif_s3_rob.arn
# }