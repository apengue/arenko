variable "environment" {
  description = "the environment name"
  type        = string
  validation {
    condition     = contains(["dev", "test", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}

variable "service" {
  description = "the service name"
  type        = string
}

variable "aws_region" {
  description = "aws region"
  type        = string
  default     = "eu-west-1"
}

variable "db_username" {
  description = "RDS master username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

variable "rds_multi_az" {
  type    = bool
  default = false   # override to true in prod tfvars
}

