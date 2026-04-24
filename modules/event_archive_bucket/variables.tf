variable "name_prefix" {
  description = "Prefix used for bucket naming"
  type        = string
}

variable "force_destroy" {
  description = "Allow bucket deletion with objects inside"
  type        = bool
  default     = false
}