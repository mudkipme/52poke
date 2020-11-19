terraform
=========

52Poké resources provisioned with Terraform. See [wiki](https://github.com/mudkipme/52poke/wiki/Terraform) for details.

## Importing

Some resources need to be imported before `terraform plan` or `terraform apply`.

- API Gateway APIs. [Malasada](https://github.com/mudkipme/malasada) is deployed via [Serverless Framework](https://serverless.com/framework/docs/getting-started/). We only use terraform to integrate it with other resources.
- S3 buckets. S3 buckets are pre-created. The bucket policy is managed with terraform.