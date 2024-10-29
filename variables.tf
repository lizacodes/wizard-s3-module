variable "environment" {
  type        = string
  description = "The target environment the bucket is intended for. Defaults to dev"
  default     = "development"
  validation {
    condition     = var.environment == "development" || var.environment == "stage" || var.environment == "production"
    error_message = "Valid values are development, staging and production"
  }
}

variable "aws_account_id" {
  type        = string
  description = "The AWS account ID of the target environment."
}
