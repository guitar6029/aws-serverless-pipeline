# AWS Serverless Pipeline

Learning project focused on Terraform, AWS fundamentals, and serverless architecture.

## Goals

- Learn Infrastructure as Code (Terraform)
- Learn AWS core services
- Build a serverless data processing pipeline
- Understand cloud security, IAM, and cost management
- Practice real-world infrastructure workflows

---

## Progress

### Terraform Basics

- Installed Terraform
- Created first Terraform configuration
- Learned:
  - Desired State (`main.tf`)
  - State File (`terraform.tfstate`)
  - `terraform init`
  - `terraform plan`
  - `terraform apply`
  - `terraform destroy`

### Local Provider

Created first managed resource:

```hcl
resource "local_file" "hello" {
  filename = "hello.txt"
  content  = "This is an example message text"
}
```

Learned:

- Providers are plugins
- Resources belong to providers
- Terraform tracks resources through state

### AWS Account Setup

Completed initial AWS account setup:

- MFA enabled
- Budget alerts configured
- IAM admin user created
- Access keys generated
- AWS CLI configured

Verified AWS authentication:

```bash
aws sts get-caller-identity
```

### AWS CLI Setup

```bash
sudo apt install unzip

unzip awscliv2.zip

sudo ./aws/install

aws --version

aws configure

aws sts get-caller-identity
```

### AWS Provider

Added AWS provider:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
```

Learned:

- `required_providers` downloads plugins
- `provider` configures plugins
- Terraform communicates with AWS through providers

### First AWS Resource

Created first AWS-managed resource:

```hcl
resource "aws_s3_bucket" "demo" {
  bucket = "jsdev305-aws-serverless-pipeline-demo"
}
```

Workflow:

```bash
terraform init
terraform plan
terraform apply
```

Verified:

- Bucket created in AWS
- Resource tracked in Terraform state

---

## Current Infrastructure

- Local File
  - `local_file.hello`

- AWS
  - `aws_s3_bucket.demo`

---

## Next Steps

- S3 Versioning
- S3 Encryption
- Terraform Variables
- Terraform Outputs
- IAM Best Practices
- Lambda Functions
- S3 Event Triggers
- Serverless Data Pipeline

```

```
