# Global variables
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "The default region for our Test/Dev environment."
}

# App variables

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
}


# Network variables



# Security variables

variable "db_password" {
  description = "The password for the database"
  type        = string
}


