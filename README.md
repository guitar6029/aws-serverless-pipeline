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

- `required_providers` downloads provider plugins
- `provider` configures provider settings
- Terraform communicates with AWS through providers

### First AWS Resource

Created first AWS-managed resource:

```hcl
resource "aws_s3_bucket" "demo" {
  bucket = "jsdev305-aws-serverless-pipeline-demo"
}
```

Learned:

- Terraform resources map to real AWS infrastructure
- Resource references avoid hardcoded values
- Terraform builds a dependency graph automatically

### S3 Tags

Added metadata tags to the bucket:

```hcl
tags = {
  Environment = "dev"
  ManagedBy   = "terraform"
  Project     = "aws-serverless-pipeline"
}
```

Learned:

- Tags help organize cloud resources
- Tags are commonly used for ownership, environments, and cost allocation

### S3 Versioning

Enabled bucket versioning:

```hcl
resource "aws_s3_bucket_versioning" "demo" {
  bucket = aws_s3_bucket.demo.id

  versioning_configuration {
    status = "Enabled"
  }
}
```

Learned:

- S3 preserves historical object versions
- Updating an object creates a new version instead of overwriting the previous one
- Version IDs are returned by AWS and tracked in Terraform state

### S3 Server-Side Encryption

Enabled default encryption:

```hcl
resource "aws_s3_bucket_server_side_encryption_configuration" "demo" {
  bucket = aws_s3_bucket.demo.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
```

Learned:

- Objects are encrypted automatically when stored
- AES256 uses AWS-managed encryption keys
- Encryption can be configured as infrastructure

### S3 Lifecycle Rules

Added lifecycle management:

```hcl
resource "aws_s3_bucket_lifecycle_configuration" "demo" {
  bucket = aws_s3_bucket.demo.id

  rule {
    id     = "cleanup-old-objects"
    status = "Enabled"

    expiration {
      days = 365
    }
  }
}
```

Learned:

- Lifecycle rules automate storage management
- Old objects can be archived or deleted automatically
- Lifecycle policies help control long-term storage costs

### S3 Object Uploads

Uploaded objects using Terraform:

```hcl
resource "aws_s3_object" "sample" {
  bucket = aws_s3_bucket.demo.id

  key    = "sample.txt"
  source = "sample.txt"

  etag = filemd5("sample.txt")
}
```

Learned:

- Terraform can manage S3 objects
- Hashes can be used to detect file changes
- Updating the local file creates a new object version in S3
- Terraform state tracks the current S3 version ID

---

## Current Infrastructure

### Local Resources

- `local_file.hello`

### AWS Resources

- `aws_s3_bucket.demo`
- `aws_s3_bucket_versioning.demo`
- `aws_s3_bucket_server_side_encryption_configuration.demo`
- `aws_s3_bucket_lifecycle_configuration.demo`
- `aws_s3_object.sample`

### Current S3 Features

- Versioning Enabled
- AES256 Encryption Enabled
- Lifecycle Rule (365-day expiration)
- Managed Object Uploads
- Terraform State Tracking

---

## Key Concepts Learned

- Desired State vs Actual State
- Terraform State Management
- Providers vs Resources
- Resource References
- Dependency Graphs
- Infrastructure Drift Detection
- Hash-Based Change Detection (`filemd5`)
- S3 Object Versioning
- Server-Side Encryption
- Lifecycle Management

---

## Next Steps

- Terraform Variables
- Terraform Outputs
- Terraform Modules
- IAM Roles and Policies
- Lambda Functions
- S3 Event Notifications
- CloudWatch Logging
- Serverless Data Processing Pipeline
- Remote Terraform State
- CI/CD Deployment Pipeline
