variable "bucket_name" {
  type        = string
  description = "The name of the bucket."
}

variable "environment" {
  type        = string
  description = "The environment for the bucket."
}

variable "owner" {
  type        = string
  description = "The owner of the bucket. This can be a team name."
}

variable "tags" {
  type        = map(string)
  description = "Tags to add to the bucket."
  default     = {}
}

variable "acl" {
  type        = string
  description = "The ACL for the bucket. Defaults to private. See Amazon docs for options: https://docs.aws.amazon.com/AmazonS3/latest/userguide/acl-overview.html#canned-acl"
  default     = "private"
}

variable "policyStatements" {
  type        = list(object({
    Effect    = string
    Action    = string
    Resource  = string
    Principal = map(list(string))
  }))
  description = "The policy statements to add to the bucket."
}
