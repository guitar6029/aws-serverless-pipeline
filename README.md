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

Learned:

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

Verified authentication:

```bash
aws sts get-caller-identity
```

### AWS Provider

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

- Terraform providers are plugins
- Providers configure communication with AWS
- Terraform manages infrastructure through providers

---

## S3 Storage

### Bucket

```hcl
resource "aws_s3_bucket" "demo" {
  bucket = "jsdev305-aws-serverless-pipeline-demo"
}
```

### Tags

```hcl
tags = {
  Environment = "dev"
  ManagedBy   = "terraform"
  Project     = "aws-serverless-pipeline"
}
```

### Versioning

```hcl
resource "aws_s3_bucket_versioning" "demo" {
  bucket = aws_s3_bucket.demo.id

  versioning_configuration {
    status = "Enabled"
  }
}
```

### Encryption

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

### Lifecycle Rules

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

- Versioning preserves historical object versions
- Encryption protects data at rest
- Lifecycle rules automate storage management
- Tags improve organization and cost tracking

---

## IAM and Security

### Lambda Execution Role

```hcl
resource "aws_iam_role" "lambda_role" {
  name = "aws-serverless-pipeline-lambda-role"
}
```

Learned:

- IAM Roles and Policies are separate resources
- Trust Policies define who can assume a role
- Permission Policies define what a role can do
- AWS follows a deny-by-default model

### CloudWatch Permissions

```hcl
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
```

### S3 Read Permissions

Lambda execution role granted:

```text
s3:GetObject
```

Learned:

- Lambda execution permissions are independent from invocation permissions
- Principle of Least Privilege
- AWS evaluates permissions based on the calling identity

---

## Lambda

### Initial Function

```python
def handler(event, context):
    print("Hello from Lambda")

    return {
        "statusCode": 200
    }
```

Learned:

- Lambda code is deployed as a zip package
- AWS handlers follow `file.function`
- Terraform can deploy application code
- `source_code_hash` detects code changes

### CloudWatch Logs

Learned:

- Lambda automatically writes logs to CloudWatch
- CloudWatch provides logs, metrics, dashboards, and alarms
- Logging is critical for debugging serverless applications

---

## Event-Driven Architecture

### Lambda Invocation Permissions

```hcl
resource "aws_lambda_permission" "allow_s3" {
  action        = "lambda:InvokeFunction"
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.demo.arn
}
```

### S3 Event Notifications

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
- Event-driven systems reduce manual workflows
- Notifications define WHEN actions occur
- Permissions define WHO may perform actions

---

## Terraform Dependencies

Implicit dependency:

```hcl
role = aws_iam_role.lambda_role.arn
```

Explicit dependency:

```hcl
depends_on = [
  aws_lambda_permission.allow_s3
]
```

Learned:

- Terraform builds dependency graphs automatically
- Resource references create implicit dependencies
- `depends_on` creates explicit dependencies
- Explicit dependencies help prevent race conditions

---

## Payment Processing Pipeline

Implemented an event-driven CSV ingestion workflow using S3, Lambda, Boto3, and Pydantic.

## DynamoDB

### Payments Table

```hcl
resource "aws_dynamodb_table" "payments" {
  name         = "payments"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "payment_id"

  attribute {
    name = "payment_id"
    type = "N"
  }
}
```

### IAM Permissions

Lambda execution role granted:

```text
dynamodb:PutItem
```

against:

```text
payments
```

### Learned

- DynamoDB is a NoSQL database
- DynamoDB models access patterns rather than relationships
- Primary keys determine data access
- Non-key attributes do not need schema definitions
- IAM permissions should follow Least Privilege
- Terraform can manage DynamoDB resources
- Infrastructure drift can occur when AWS resources are modified manually

### Architecture

```
client_payments.csv
        ↓
        S3
        ↓
Event Notification
        ↓
     Lambda
        ↓
S3 GetObject
        ↓
CSV Parsing
        ↓
Pydantic Validation
        ↓
CloudWatch Logs

        Future
           ↓

       DynamoDB
```

### Lambda Structure

```text
lambda/
├── handler.py
├── models/
│   └── payment.py
├── processors/
│   └── payments.py
├── pyproject.toml
└── uv.lock
```

### Components

#### Payment Model

```python
class Payment(BaseModel):
    payment_id: int
    client: str
    amount: float
    date: date
    status: PaymentStatus
```

#### Payment Status

```python
class PaymentStatus(str, Enum):
    PAID = "paid"
    PENDING = "pending"
    FAILED = "failed"
```

#### Processing Flow

- Read object from S3
- Stream rows line-by-line
- Skip CSV header
- Parse payment records
- Validate with Pydantic
- Log results to CloudWatch

### Runtime Compatibility Debugging

Issue:

```text
No module named 'pydantic_core._pydantic_core'
```

Root Cause:

- Local Python 3.12
- Lambda Python 3.13
- Pydantic Core compiled for Python 3.12

Resolution:

- Updated Lambda runtime to Python 3.12

Learned:

- Runtime versions matter
- Deployment artifacts include dependencies
- Build and runtime environments should match
- CloudWatch is essential for debugging deployment issues

---

## Current Infrastructure

### AWS Resources

aws_s3_bucket.demo
aws_s3_bucket_versioning.demo
aws_s3_bucket_server_side_encryption_configuration.demo
aws_s3_bucket_lifecycle_configuration.demo
aws_iam_role.lambda_role
aws_iam_role_policy_attachment.lambda_basic_execution
aws_iam_role_policy.lambda_s3_read
aws_iam_role_policy.lambda_dynamodb_write
aws_lambda_function.demo
aws_lambda_permission.allow_s3
aws_s3_bucket_notification.demo
aws_dynamodb_table.payments

### Current Architecture

```text
client_payments.csv
        ↓
        S3
        ↓
Event Notification
        ↓
     Lambda
        ↓
S3 GetObject
        ↓
CSV Parsing
        ↓
Pydantic Validation
        ↓
CloudWatch Logs
```

---

## Key Concepts Learned

- Terraform State Management
- Providers vs Resources
- Desired State vs Actual State
- Dependency Graphs
- Implicit vs Explicit Dependencies
- Infrastructure Drift
- S3 Versioning
- S3 Encryption
- Lifecycle Policies
- IAM Roles vs Policies
- Trust Policies
- Lambda Execution Roles
- Lambda Invocation Permissions
- Event-Driven Architecture
- CloudWatch Logging
- Lambda Deployment Packaging
- Runtime Compatibility
- Dependency Management
- Pydantic Validation
- CSV Processing Pipelines
- DynamoDB Fundamentals
- NoSQL vs Relational Databases
- Access Pattern Design
- Partition Keys
- Inline IAM Policies
- Infrastructure Drift
- Infrastructure as Code Workflows

### Infrastructure Drift

Learned:

- Terraform is the source of truth
- Manual AWS Console changes can cause drift
- `terraform plan` detects drift
- `terraform apply` restores desired state
- Infrastructure changes should be reviewed through code

---

## Future Experiments

### IAM Authorization Patterns

Topics to explore:

- Prefix-based authorization
- Role separation
- Fine-grained S3 access control
- Least Privilege strategies
- Human vs Service identities

### Single Lambda vs Multiple Lambdas

Start with a single Lambda when:

- Same trigger
- Same permissions
- Same deployment lifecycle

Split into multiple Lambdas when:

- Different permissions
- Different event sources
- Different business domains
- Different scaling requirements

### Next Milestones

- Persist validated payments into DynamoDB
- Query payments from DynamoDB
- API Lambda
- API Gateway
- CloudWatch Metrics
- CloudWatch Alarms
- Terraform Modules
- Remote Terraform State
- CI/CD Pipelines
- Dead Letter Queues
- CSV Aggregation and Reporting
