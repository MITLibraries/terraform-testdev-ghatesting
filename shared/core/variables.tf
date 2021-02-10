# Global variables
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "The default region for our Test/Dev environment."
}

# A list of IAM accounts to create (usernames) including accounts to be
# added to the administrators group
variable "users" {
  description = "A list of IAM accounts to create (usernames)"
  type        = list
  default     = []
}
