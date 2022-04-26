variable "bucket_source" {
  type    = string
  default = "genomics-source-vkjhf87tg89t9fi"
}

variable "bucket_dest" {
  type    = string
  default = "genomics-destination-vkjhf87tg89t9fi"
}

variable "tags" {
  type = map(string)
  default = { environment = "dev"
    project    = "genomics"
    owner      = "gtampi/devops"
    created_by = "terraform"
  }
}

module "s3_bucket_a" {

  source = "terraform-aws-modules/s3-bucket/aws"

  bucket                  = var.bucket_source
  acl                     = "private"
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  object_ownership = "BucketOwnerEnforced"

  versioning = {
    enabled = true
  }

  tags = var.tags
}


module "s3_bucket_b" {

  source = "terraform-aws-modules/s3-bucket/aws"

  bucket                  = var.bucket_dest
  acl                     = "private"
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  object_ownership = "BucketOwnerEnforced"

  versioning = {
    enabled = true
  }

  tags = var.tags
}
