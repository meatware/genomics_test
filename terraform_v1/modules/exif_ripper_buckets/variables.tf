variable "env" {
  type = string
}

variable "random_string" {
  type = string
}


variable "bucket_source" {
  type = string
}

variable "bucket_dest" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "ssm_root_path" {
  type = string
}