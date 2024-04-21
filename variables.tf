variable "env" {
  type = string
}

variable "s3_bucket" {
  description = "The bucket with Lambda Function"
  type        = string
}

variable "s3_key" {
  description = "The zip file with Lambda Funtion"
  type        = string
}

