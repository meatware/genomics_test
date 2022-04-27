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

variable "ssm_root_path" {
  type    = string
  default = "/genomics/exif-ripper"
}