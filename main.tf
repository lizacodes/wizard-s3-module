provider "aws" {
  region = "ap-southeast-2"
}

module "my_bucket" {
  source      = "./modules/wizardai_aws_s3_bucket"
  bucket_name = "my-bucket"
  owner       = "keanu"
  environment = var.environment
  policyStatements = [
    {
      Effect    = "Allow"
      Action    = "s3:GetObject"
      Resource  = "${module.my_bucket.arn}/*"
      Principal = {
        AWS = ["arn:aws:iam::${var.aws_account_id}:root"]
      }
    }
  ]
}
