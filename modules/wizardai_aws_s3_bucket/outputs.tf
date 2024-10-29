output "name" {
  description = "Bucket name (ID)"
  value       = aws_s3_bucket.bucket.id
}

output "arn" {
  description = "Bucket ARN"
  value       = aws_s3_bucket.bucket.arn
}

output "domain_name" {
  description = "The bucket domain name"
  value       = aws_s3_bucket.bucket.bucket_domain_name
}
