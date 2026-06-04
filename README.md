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

### IAM Role for Lambda

Created a dedicated execution role for Lambda:

```hcl
resource "aws_iam_role" "lambda_role" {
  name = "aws-serverless-pipeline-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Action = "sts:AssumeRole"

        Effect = "Allow"

        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}
```

Learned:

- IAM Roles and Policies are separate resources
- Trust Policies define who can assume a role
- Permission Policies define what a role can do
- Lambda assumes an IAM Role during execution
- AWS follows a deny-by-default security model

### Lambda CloudWatch Permissions

Attached AWS managed logging permissions:

```hcl
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
```

Learned:

- Policies can exist independently from roles
- Roles can exist independently from policies
- Attaching a policy grants permissions to the role
- Lambda requires CloudWatch permissions to write logs
- Principle of Least Privilege

### First Lambda Function

Created and deployed a Python Lambda function:

```python
def handler(event, context):
    print("Hello from Lambda")

    return {
        "statusCode": 200,
        "message": "Lambda executed successfully"
    }
```

Terraform configuration:

```hcl
resource "aws_lambda_function" "demo" {
  function_name = "aws-serverless-pipeline-demo"

  role = aws_iam_role.lambda_role.arn

  runtime = "python3.13"

  handler = "handler.handler"

  filename = "../lambda/handler.zip"

  source_code_hash = filebase64sha256("../lambda/handler.zip")

  timeout     = 5
  memory_size = 128
}
```

Learned:

- Lambda code is deployed as a zip package
- AWS uses the format `file.function` for handlers
- Resource references connect infrastructure components
- `source_code_hash` allows Terraform to detect code changes
- Lambda code, IAM, and infrastructure are managed independently

### CloudWatch Logs

Successfully executed the Lambda function and verified logging.

Learned:

- CloudWatch is AWS's native observability platform
- Lambda automatically creates log groups and log streams
- Application logs are available through CloudWatch Logs
- Logging is essential for debugging serverless applications
- CloudWatch provides logs, metrics, dashboards, and alarms

````


### Lambda Invocation Permissions

Granted S3 permission to invoke the Lambda function:

```hcl
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.demo.function_name

  principal = "s3.amazonaws.com"

  source_arn = aws_s3_bucket.demo.arn
}
````

Learned:

- Lambda execution permissions are separate from IAM execution roles
- S3 requires explicit permission before invoking Lambda
- `source_arn` restricts invocation to a specific bucket
- AWS validates permissions before creating event notifications
- Resource relationships often require multiple Terraform resources

### S3 Event Notifications

Connected S3 uploads to Lambda using bucket notifications:

```hcl
resource "aws_s3_bucket_notification" "demo" {
  bucket = aws_s3_bucket.demo.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.demo.arn

    events = [
      "s3:ObjectCreated:*"
    ]
  }

  depends_on = [
    aws_lambda_permission.allow_s3
  ]
}
```

Learned:

- S3 can emit events when objects are created
- Event notifications connect AWS services together
- Event-driven architecture reduces manual operations
- Notifications define WHEN actions occur
- Permissions define WHO may perform actions

### Terraform Dependencies

Learned the difference between implicit and explicit dependencies.

Implicit dependency example:

```hcl
role = aws_iam_role.lambda_role.arn
```

Explicit dependency example:

```hcl
depends_on = [
  aws_lambda_permission.allow_s3
]
```

Learned:

- Terraform builds a dependency graph automatically
- Resource references create implicit dependencies
- `depends_on` creates explicit dependencies
- Explicit dependencies help prevent race conditions
- Some AWS relationships are not automatically discoverable by Terraform

## Current Infrastructure

### Local Resources

- `local_file.hello`

### AWS Resources

- `aws_s3_bucket.demo`
- `aws_s3_bucket_versioning.demo`
- `aws_s3_bucket_server_side_encryption_configuration.demo`
- `aws_s3_bucket_lifecycle_configuration.demo`
- `aws_s3_object.sample`
- `aws_iam_role.lambda_role`
- `aws_iam_role_policy_attachment.lambda_basic_execution`
- `aws_lambda_function.demo`
- `aws_lambda_permission.allow_s3`
- `aws_s3_bucket_notification.demo`

### Current Architecture

```text
S3 Upload
      ↓
S3 Event Notification
      ↓
Lambda Function
      ↓
CloudWatch Logs
```

### Current S3 Features

- Versioning Enabled
- AES256 Encryption Enabled
- Lifecycle Rule (365-day expiration)
- Managed Object Uploads
- Event Notifications
- Terraform State Tracking

## Key Concepts Learned

- Desired State vs Actual State
- Terraform State Management
- Providers vs Resources
- Resource References
- Implicit Dependencies
- Explicit Dependencies (`depends_on`)
- Dependency Graphs
- Infrastructure Drift Detection
- Hash-Based Change Detection (`filemd5`)
- S3 Object Versioning
- Server-Side Encryption
- Lifecycle Management
- IAM Roles vs Policies
- Trust Policies
- Lambda Execution Roles
- Event-Driven Architecture
- S3 Event Notifications
- Lambda Invocation Permissions
- CloudWatch Logging
- AWS Region Awareness
- Race Conditions in Infrastructure Provisioning

### IAM Authorization Patterns (Future Topics)

Scenario:

Bucket contains different classes of data:

- public/\*
- finance/\*
- admin/\*

Different identities may require different permissions:

Users:

- Default users may access public/\*
- Finance users may access finance/\*
- Admins may access all resources

Lambda:

- Can have completely different permissions than human users
- May read uploads/\*
- May write processed/\*
- May access DynamoDB while users cannot

Key Learning:

AWS always evaluates permissions based on the identity making the request.

Examples:

AWS CLI
→ User IAM permissions

Lambda
→ Lambda execution role permissions

EC2
→ EC2 instance role permissions

Important Question During Debugging:

"Who is making this request?"

Least Privilege:

Grant only the actions required:

- s3:GetObject
- s3:PutObject
- dynamodb:PutItem

Avoid broad permissions such as:

- s3:\*
- -

Scalability:

Prefer prefixes/folders:

- public/\*
- finance/\*
- admin/\*

instead of managing permissions for thousands of individual files.

Single Lambda vs Multiple Lambdas

Start with a single Lambda when:

- Same trigger
- Same permissions
- Same deployment lifecycle

Split into multiple Lambdas when:

- Different permissions
- Different event sources
- Different business domains
- Different scaling requirements
