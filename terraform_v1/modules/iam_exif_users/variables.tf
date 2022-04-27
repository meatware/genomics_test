variable "env" {
  type = string
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
  type = map(string)
}