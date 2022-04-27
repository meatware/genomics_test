resource "aws_iam_group_policy" "exif_pol_ro" {

  #for_each = length(var.user_maps) > 0 ? var.user_maps : {}

  name  = "exif_${var.env}_s3_ro_policy"
  group = aws_iam_group.exifripper_s3_ro.name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:ListAllMyBuckets"
        ],
        "Resource" : "arn:aws:s3:::*"
      },
      {
        "Effect" : "Deny",
        "Action" : [
          "s3:ListBucket"
        ],
        "NotResource" : [
          "arn:aws:s3:::genomics-source-dev-vkjhf87tg89t9fi",
          "arn:aws:s3:::genomics-source-dev-vkjhf87tg89t9fi/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:GetObject"
        ],
        "Resource" : [
          "arn:aws:s3:::genomics-source-dev-vkjhf87tg89t9fi",
          "arn:aws:s3:::genomics-source-dev-vkjhf87tg89t9fi/*"
        ]
      }
    ]
  })
}

resource "aws_iam_group_policy" "exif_pol_rw" {

  #for_each = length(var.user_maps) > 0 ? var.user_maps : {}

  name  = "exif_${var.env}_s3_ro_policy"
  group = aws_iam_group.exifripper_s3_ro.name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:ListAllMyBuckets"
        ],
        "Resource" : "arn:aws:s3:::*"
      },
      {
        "Effect" : "Deny",
        "Action" : [
          "s3:ListBucket"
        ],
        "NotResource" : [
          "arn:aws:s3:::genomics-source-dev-vkjhf87tg89t9fi",
          "arn:aws:s3:::genomics-source-dev-vkjhf87tg89t9fi/*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:GetObject"
        ],
        "Resource" : [
          "arn:aws:s3:::genomics-source-dev-vkjhf87tg89t9fi",
          "arn:aws:s3:::genomics-source-dev-vkjhf87tg89t9fi/*"
        ]
      }
    ]
  })
}