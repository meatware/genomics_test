variable "env" {
  type    = string
  default = "dev"
}

variable "ssm_root_path" {
  type    = string
  default = "/genomics/exifripper"
}

locals {
  tags = {
    environment = var.env
    project     = "genomics"
    owner       = "gtampi/devops"
    created_by  = "terraform"
  }

}

module "exif_buckets" {
  source = "../modules/exif_ripper_buckets"

  env           = var.env
  random_string = "vkjhf87tg89t9fi"
  bucket_source = "genomics-source"
  bucket_dest   = "genomics-destination"

  tags = local.tags

  ssm_root_path = var.ssm_root_path

}

module "lambda_role_and_policies" {
  source = "../modules/lambda_iam_role_and_policies"

  env           = var.env
  bucket_source = module.exif_buckets.bucket_source_name
  bucket_dest   = module.exif_buckets.bucket_dest_name

  tags = local.tags

  ssm_root_path = var.ssm_root_path
}

module "iam_exif_users" {
  source = "../modules/iam_exif_users"

  env          = var.env
  tags         = local.tags
  ro_user_list = ["user_b"]
  rw_user_list = ["user_a"]

}
