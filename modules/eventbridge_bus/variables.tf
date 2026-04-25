variable "name_prefix" {
  description = "Global resource naming prefix"
  type        = string
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
}