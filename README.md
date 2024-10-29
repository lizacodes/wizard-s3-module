## Wizard AI S3 Bucket Module

### Demo

#### Prequisites

- Local AWS credentials that allow S3 resource creation and management in the account
- The AWS account ID on hand

#### Run the demo

In the root directory of this project:

1. Run `terraform init` to install required dependencies
2. Run `terraform plan` and enter the AWS account ID to preview
3. Run `terraform apply` and enter the AWS account ID to deploy

### Example usage

```hcl
module "wizard_storage" {
  source      = "./modules/wizardai_aws_s3_bucket"
  bucket_name = "my-bucket"
  owner       = "frontend-team"
  environment = var.environment
  bucket_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          AWS = ["arn:aws:iam::${var.aws_account_id}:root"]
        }
        Action    = "s3:GetObject"
        Resource  = ["${module.my_bucket.arn}/*"]
      }
    ]
  })
}
```

### Assumptions

I want to cover off some assumptions about how Wizard AI for the purposes of the exercise:

- Uses automated CI/CD processes to deploy infrastructure
- Multiple AWS accounts/environments exist for development, testing and production purposes
- Each environment is similar in configuration

For brevity, I've included bare minimum configuration to show a working example of the module for the "development" environment.

### Design rationale

The overall intention is make it easy for the user of the module to focus on configuring parts of the bucket most relevant to them, while ensuring the configuration adheres to best practices.

Things the user doesn't have to think about:

- Bucket name uniqueness - the module tries to make sure the name is globally by using namespacing and generating a unique suffix (this was not in the requirements but the demo is less likely to go wrong this way)
- Tagging standards - a set of default tags are included in addition to tags that the user wants to include. These default tags can be used for multiple purposes, but at minimum it can be used for cost visibility
- Accidentally creating a public bucket
- Correctly setting up data encryption

The module doesn't make any assumptions about what the bucket will be used for. Engineers should still consider what kind of security applies to the bucket.

Due to AWS's default behaviour for "private" ACL, the encryption in transit policy will not apply in that particular case.

### Future improvements

- Enforcing owners to known list of teams
- Add any other tags that are relevant to organisation policies
- Designing sensible defaults for common use cases - eg. static public bucket, log storage, etc
- Default bucket deletion policies
- Enforcing bucket creation policies at the organisational level in SCPs
