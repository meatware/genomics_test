variable "bucket_name" {
  type    = string
  default = "serverless-deployment-holder-658fi8r7"
}

module "s3_dbucket" {

  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.bucket_name
  acl    = "private"

  versioning = {
    enabled = true
  }

}

# module "s3_bucket" {
#   source = "cloudposse/s3-bucket/aws"
#   # Cloud Posse recommends pinning every module to a specific version
#   # version = "x.x.x"
#   acl                      = "private"
#   enabled                  = true
#   user_enabled             = true
#   versioning_enabled       = false
#   allowed_bucket_actions   = ["s3:GetObject", "s3:ListBucket", "s3:GetBucketLocation"]
#   name                     = var.bucket_name
#   stage                    = "dev"
#   namespace                = "genomics"
# }