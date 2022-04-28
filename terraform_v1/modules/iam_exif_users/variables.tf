variable "env" {
  description = "Deployment environment. e.g. dev, uat, prod"
  type        = string
}

variable "ro_user_list" {
  type = list(string)
}

variable "rw_user_list" {
  type = list(string)
}

# variable "user_maps" {
#   type = map(map(string))
# }

variable "tags" {
  description = "A map that is used to apply tags to resources created by terraform"
  type        = map(string)
}