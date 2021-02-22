# AWS variables
variable "region" {
  description = "AWS region to be used for resources"
  type        = string
  default     = "us-east-1"
}

# S3 variables
variable "bucketname" {
  description = "The name of the thesis submit bucket"
  type        = string
  default = "testdev_bucketname"
}

variable "s3_cors_rule" {
  description = "The CORS rule for the bucket to allow cross-origin access"
}
