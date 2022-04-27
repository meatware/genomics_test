variable "bucket_name" {
  type    = string
  default = "serverless-deployment-holder-658fi8r7"
}

variable "tags" {
  type = map(string)
  default = { environment = "dev"
    project    = "genomics"
    owner      = "gtampi/devops"
    created_by = "terraform"
  }
}

module "s3_serverless_deployment_bucket" {

  source = "terraform-aws-modules/s3-bucket/aws"

  bucket                  = var.bucket_name
  acl                     = "private"
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  object_ownership = "BucketOwnerEnforced"

  force_destroy = true

  versioning = {
    enabled = true
  }

  tags = var.tags
}
