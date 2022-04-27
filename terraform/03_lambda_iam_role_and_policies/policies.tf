resource "aws_iam_role_policy" "test_policy" {
  name_prefix = local.lambda_role_name

  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "logs:CreateLogStream",
          "s3:ListBucket",
          "logs:CreateLogGroup",
          "s3:PutObjectAcl"
        ],
        "Resource" : [
          "arn:aws:logs:eu-west-1:779934699932:log-group:/aws/lambda/exif-ripper-dev-exif",
          "arn:aws:logs:eu-west-1:779934699932:log-group:/aws/lambda/exif-ripper-dev*:*",
          "arn:aws:s3:::genomics-source-vkjhf87tg89t9fi",
          "arn:aws:s3:::genomics-destination-vkjhf87tg89t9fi",
          "arn:aws:s3:::serverless-deployment-holder-658fi8r7",
          "arn:aws:s3:::serverless-deployment-holder-658fi8r7/*",
          "arn:aws:s3:::genomics-source-vkjhf87tg89t9fi/*",
          "arn:aws:s3:::genomics-destination-vkjhf87tg89t9fi/*"
        ]
      },
      {
        "Sid" : "VisualEditor1",
        "Effect" : "Allow",
        "Action" : [
          "ssm:Get*",
          "ssm:List*",
          "ssm:Describe*",
          "logs:PutLogEvents"
        ],
        "Resource" : [
          "*"
          # "arn:aws:ssm:eu-west-1:779934699932:parameter//genomics/exif-ripper/dev/*",
          # "arn:aws:logs:eu-west-1:779934699932:log-group:/aws/lambda/exif-ripper-dev-exif:log-stream:*",
          # "arn:aws:logs:eu-west-1:779934699932:log-group:/aws/lambda/exif-ripper-dev*:*:*"
        ]
      }
    ]
  })

  lifecycle {
    create_before_destroy = true
  }  
}

