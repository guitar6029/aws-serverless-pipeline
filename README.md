# AWS Serverless Pipeline

Learning project focused on Terraform, AWS, Docker, and modern cloud-native backend development.

Originally created to explore AWS serverless architecture, this repository is gradually evolving into the foundation for a larger cloud-native engineering platform.

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

```
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

```
aws sts get-caller-identity
```

### AWS Provider

```
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

```
resource "aws_s3_bucket" "demo" {
  bucket = "jsdev305-aws-serverless-pipeline-demo"
}
```

### Tags

```
tags = {
  Environment = "dev"
  ManagedBy   = "terraform"
  Project     = "aws-serverless-pipeline"
}
```

### Versioning

```
resource "aws_s3_bucket_versioning" "demo" {
  bucket = aws_s3_bucket.demo.id

  versioning_configuration {
    status = "Enabled"
  }
}
```

### Encryption

```
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

```
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

```
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

```
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
```

### S3 Read Permissions

Lambda execution role granted:

```
s3:GetObject
```

Learned:

- Lambda execution permissions are independent from invocation permissions
- Principle of Least Privilege
- AWS evaluates permissions based on the calling identity

---

## Lambda

### Initial Function

```
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

```
resource "aws_lambda_permission" "allow_s3" {
  action        = "lambda:InvokeFunction"
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.demo.arn
}
```

### S3 Event Notifications

```
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

```
role = aws_iam_role.lambda_role.arn
```

Explicit dependency:

```
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

## DynamoDB Persistence

Implemented persistent storage of payment records using DynamoDB.

```
Architecture:

CSV
 ↓
S3
 ↓
Lambda
 ↓
Pydantic Validation
 ↓
DynamoDB
DynamoDB Table

```

resource "aws_dynamodb_table" "payments" {
name = "payments"
billing_mode = "PAY_PER_REQUEST"
hash_key = "payment_id"

attribute {
name = "payment_id"
type = "N"
}
}

DynamoDB IAM Permissions

Lambda execution role granted:

dynamodb:PutItem
Repository Layer
lambda/
├── repositories/
│ └── payments.py

Purpose:

Separate persistence from business logic
Keep handler focused on orchestration
Allow storage implementation changes later
Decimal vs Float

Issue encountered:

Float types are not supported.
Use Decimal types instead.

Resolution:

from decimal import Decimal
amount: Decimal

Learned:

-DynamoDB uses Decimal for numeric precision
-Float is unsuitable for financial data
-Monetary values require deterministic precision

### Payments Table

```
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

```
dynamodb:PutItem
```

against:

```
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
CSV Parsing
        ↓
Pydantic Validation
        ↓
DynamoDB Persistence
        ↓
   DynamoDB Table

```

### Lambda Structure

```
lambda/
├── handler.py
├── models/
│   └── payment.py
├── processors/
│   └── payments.py
├── pyproject.
utils/
├── payment_filters.py
├── payment_response.py
toml
└── uv.lock
```

### Components

#### Payment Model

```
class Payment(BaseModel):
    payment_id: int
    client: str
    amount: Decimal
    date: date
    status: PaymentStatus
```

#### Payment Status

```
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

```
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

---

# Payments API

Implemented a serverless REST API for retrieving payment records from DynamoDB.

## Payment Filtering

Implemented query parameter filtering for payment retrieval endpoints.

### Supported Filters

```
GET /payments?status=paid

GET /payments?min_amount=500

GET /payments?max_amount=1000

GET /payments?status=paid&min_amount=500
```

### Architecture

```
Client Request
        ↓
API Gateway
        ↓
Payments API Lambda
        ↓
Query Parameter Parsing
        ↓
PaymentFilters
        ↓
DynamoDB Filter Expression
        ↓
DynamoDB Scan
        ↓
Response Mapping
        ↓
JSON Response
```

### Payment Filters Model

```
@dataclass
class PaymentFilters:
    status: PaymentStatus | None = None
    client: str | None = None
    min_amount: Decimal | None = None
    max_amount: Decimal | None = None
```

### Filter Expression Builder

Implemented dynamic DynamoDB filter generation using Boto3 condition expressions.

Example:

```
Attr("status").eq("paid")

Attr("amount").gte(Decimal("500"))

Attr("amount").lte(Decimal("1000"))
```

Multiple filters are combined using logical AND operations.

### Response Mapping

Introduced a dedicated response-mapping layer to separate:

- Domain models
- DynamoDB persistence models
- API response models

Example:

```
DynamoDB Item
      ↓
payment_to_response()
      ↓
JSON Response
```

### Serialization Lessons

Issue encountered:

```
Object of type Decimal is not JSON serializable
```

Root Cause:

DynamoDB stores numeric values as Decimal objects.

Resolution:

Added response mapping that converts DynamoDB-specific types into API-friendly response objects before JSON serialization.

### DynamoDB Data Modeling Lesson

Issue encountered:

Amount values were stored as String attributes in DynamoDB.

Root Cause:

```
payment.model_dump(mode="json")
```

converted Decimal values into strings before persistence.

Resolution:

Implemented explicit persistence mapping to preserve:

```
payment_id -> Number
amount     -> Number
date       -> String
status     -> String
client     -> String
```

Learned:

- API serialization and database serialization are different concerns
- DynamoDB numeric values should be stored as Number attributes
- JSON representations are not always appropriate for persistence
- Different application layers often require different data representations
- Response mapping improves maintainability and separation of concerns



## Event-Driven Payment Processing

To improve scalability and decouple API requests from database writes, payment creation was migrated from a synchronous workflow to an asynchronous event-driven architecture using Amazon SQS.

### Previous Architecture

```
Client
    ↓
API Gateway
    ↓
Create Payment Lambda
    ↓
DynamoDB
```

In this design, API requests directly wrote to DynamoDB. While simple, the API became responsible for validation, persistence, and error handling within a single request cycle.

### Current Architecture

```
Client
    ↓
API Gateway
    ↓
Create Payment Lambda
    ↓
Amazon SQS
    ↓
Payment Worker Lambda
    ↓
DynamoDB
```

### Flow

1. Client submits a payment creation request.
2. API Gateway invokes the Create Payment Lambda.
3. Request body is validated using Pydantic.
4. A payment message is created and published to Amazon SQS.
5. The API immediately returns `202 Accepted`.
6. SQS invokes the Payment Worker Lambda through an Event Source Mapping.
7. The worker processes the message and persists the payment record to DynamoDB.

### IAM Design

Separate IAM roles were created for each workload:

**Payments API Role**

* DynamoDB Read
* DynamoDB Write
* SQS SendMessage

**Payment Worker Role**

* DynamoDB PutItem
* AWSLambdaBasicExecutionRole
* AWSLambdaSQSQueueExecutionRole

This follows the Principle of Least Privilege by granting only the permissions required for each workload.

### Lessons Learned

* Event Source Mappings automatically connect SQS queues to Lambda functions.
* SQS consumers require queue execution permissions.
* API Gateway and SQS invoke Lambda differently.
* Queue-based architectures help absorb traffic spikes.
* CloudWatch logs are essential when debugging distributed workflows.
* JSON serialization differs from DynamoDB persistence requirements.
* Decimal values require special handling when serializing queue messages.

### Benefits

* Decoupled API and persistence layers
* Improved scalability
* Better fault isolation
* Retry support through SQS
* Foundation for future DLQ and reprocessing workflows



## API Gateway

### Resources

```
/payments
/payments/{payment_id}
```

### Method

```
GET
```

### Integration

```
AWS_PROXY
```

Learned:

- API Gateway resources define URL paths
- Methods define supported HTTP verbs
- Integrations define backend targets
- Proxy integrations forward requests directly to Lambda
- API Gateway deployments create immutable snapshots
- Stages expose deployments through public URLs

## Lambda Proxy Integration

```
Client Request
        ↓
API Gateway
        ↓
Lambda Event
        ↓
Lambda Response
        ↓
API Gateway Response
```

Learned:

- API Gateway invokes Lambda using an internal AWS integration request
- Client HTTP methods are independent from integration HTTP methods
- Lambda proxy integrations pass request context automatically
- Path parameters are available through `event["pathParameters"]`

## Dedicated IAM Role

Created a dedicated execution role for the Payments API Lambda.

Role:

```
payments-api-role
```

Permissions:

```
dynamodb:GetItem
dynamodb:Scan
AWSLambdaBasicExecutionRole
```

Learned:

- Roles should represent workloads
- Least Privilege limits blast radius
- Different Lambdas often require different permissions
- Read and write access should be separated when practical

## Example Request

```
curl https://<api-id>.execute-api.us-east-1.amazonaws.com/dev/payments/1001
curl https://<api-id>.execute-api.us-east-1.amazonaws.com/dev/payments
```

## Example Response

```
{
  "amount": "1250.50",
  "date": "2026-04-15",
  "payment_id": 1001,
  "client": "acme corp",
  "status": "paid"
}
```

## Debugging Lessons

### Missing Lambda Handler

Issue:

```
Unable to import module 'handler'
```

Root Cause:

Terraform Lambda handler configuration referenced the wrong file.

Resolution:

```
handler.handler
        ↓
ingestion_handler.handler
```

### IAM Access Denied

Issue:

```
AccessDeniedException
dynamodb:GetItem
```

Root Cause:

Payments API Lambda lacked DynamoDB read permissions.

Resolution:

Created a dedicated IAM role with:

```
dynamodb:GetItem
```

Learned:

- Invocation permissions and execution permissions are separate concerns
- CloudWatch logs are the primary debugging tool for Lambda workloads
- AWS error messages are often highly specific and actionable

### API Gateway Deployment and IAM Debugging

Issue:

```
GET /payments returned 502 Internal Server Error
```

Root Cause:

API Gateway deployment snapshot was out of date
Payments API role lacked dynamodb:Scan

Resolution:

Rebuilt and redeployed Lambda package
Updated IAM policy to include dynamodb:Scan
Recreated API Gateway deployment

Learned:

-CloudWatch logs should be the first place to investigate failures
-API Gateway deployments are snapshots of API configuration
-GetItem and Scan require separate IAM permissions
-Terraform state, deployed infrastructure, and deployed Lambda code can become out of sync

## CloudWatch Monitoring

### Implemented

- Lambda Error Alarm
- CloudWatch Metrics
- CloudWatch Logs
- Alarm Testing and Recovery

### Concepts Learned

- Metrics vs Logs
- CloudWatch Alarms
- Thresholds
- Evaluation Periods
- Monitoring Production Failures

## Terraform Modules

### Concepts

- Reusable infrastructure components
- Inputs (variables)
- Outputs
- Module encapsulation
- State migration with `terraform state mv`

### Lessons Learned

- Modules reduce duplication and improve maintainability
- Outputs expose values from inside a module
- `terraform state mv` allows refactoring without recreating resources
- API Gateway requires `invoke_arn`, not a standard Lambda ARN
- Always run `terraform plan` after state operations

### Exercises

- Refactor Lambda resources into a reusable module
- Migrate existing resources using `terraform state mv`
- Expose and consume module outputs

## Terraform Remote State

### Concepts

- Local state
- Remote state
- S3 backend
- State locking
- DynamoDB locks
- Backend migration

### Lessons Learned

- Local state works for a single developer
- Remote state is shared across a team
- Terraform uses S3 as the source of truth
- DynamoDB prevents concurrent infrastructure changes
- terraform init can migrate local state to a remote backend
- terraform state mv can safely refactor resources without recreation

### Exercises

- Create S3 backend bucket
- Create DynamoDB lock table
- Migrate local state to S3
- Verify state locking

## Current Infrastructure

### AWS Resources

aws_s3_bucket.demo
aws_s3_bucket_versioning.demo
aws_s3_bucket_server_side_encryption_configuration.demo
aws_s3_bucket_lifecycle_configuration.demo

aws_iam_role.lambda_role
aws_iam_role.payments_api_role

aws_iam_role_policy.lambda_s3_read
aws_iam_role_policy.lambda_dynamodb_write
aws_iam_role_policy.payments_api_dynamodb_read

aws_lambda_function.demo
aws_lambda_function.payments_api

aws_lambda_permission.allow_s3
aws_lambda_permission.allow_payments_api

aws_s3_bucket_notification.demo

aws_dynamodb_table.payments

aws_api_gateway_rest_api.payments
aws_api_gateway_resource.payments
aws_api_gateway_resource.payment_id
aws_api_gateway_method.get_payment
aws_api_gateway_method.get_payments
aws_api_gateway_integration.get_payment
aws_api_gateway_integration.get_payments
aws_api_gateway_deployment.payments
aws_api_gateway_stage.payments

### Current Architecture

```
client_payments.csv
        ↓
        S3
        ↓
Event Notification
        ↓
Ingestion Lambda
        ↓
DynamoDB
        ↓
API Lambda
        ↓
API Gateway
        ↓
Client
```

## Dead Letter Queue (DLQ)

To improve resiliency and observability, the ingestion Lambda is configured with an Amazon SQS Dead Letter Queue (DLQ).

### Flow

S3 Upload
→ Lambda Ingestion
→ CSV Validation (Pydantic)
→ DynamoDB Persistence

On failure:

S3 Upload
→ Lambda Ingestion
→ Validation Error
→ Automatic Retry
→ Dead Letter Queue (SQS)

### Implementation

- Created an SQS queue (`ingestion-dlq`) using Terraform
- Extended the reusable Lambda Terraform module with optional DLQ support
- Added IAM permissions allowing the ingestion Lambda to send messages to SQS
- Configured Lambda asynchronous invocation retries
- Captured failed ingestion events for later inspection and reprocessing

### Validation

A test CSV containing an invalid payment amount was uploaded to S3.

Results:

- Lambda invocation failed with a Decimal conversion exception
- Error was recorded in CloudWatch Logs
- Lambda retried automatically
- Failed event was delivered to the Dead Letter Queue
- Original error details were preserved for troubleshooting

This pattern provides fault isolation, operational visibility, and a foundation for future reprocessing workflows.

---

### Reporting Endpoint

The reporting API currently computes aggregates by performing a full DynamoDB table scan and calculating totals at request time.

This approach is acceptable for learning purposes and small datasets, but it would not scale well in a production environment. As the number of records grows, full table scans become increasingly expensive and introduce higher response latency.

Future improvements may include:

- Pre-computed summary records
- Event-driven aggregate updates during ingestion
- Scheduled aggregation jobs
- Cached reporting views
- Materialized reporting tables optimized for analytics workloads

The current implementation was intentionally chosen to demonstrate DynamoDB access patterns, aggregation logic, and API-driven reporting before introducing more advanced optimization strategies.

---

## Reporting API

A reporting endpoint was added to demonstrate aggregation and analytics patterns over DynamoDB data.

Current implementation:

- GET `/reports`
- Reads payment records from DynamoDB
- Uses a DynamoDB Scan operation
- Aggregates totals by status (`paid`, `pending`, `failed`)
- Returns payment counts and monetary totals

### Production Considerations

The current implementation uses a full table scan for learning purposes.

This approach is acceptable for small datasets but becomes inefficient as table size grows.

Future improvements may include:

- Precomputed aggregates
- Materialized summary tables
- Event-driven updates via Lambda
- DynamoDB Streams
- Scheduled aggregation jobs
- Cached reporting endpoints

The goal is to evolve from on-demand computation toward incremental computation where only changed records trigger aggregate updates.

---

### API Versioning

V1:
GET /payments
GET /payments/{payment_id}

V2:
GET /v2/payments
GET /v2/payments/{payment_id}

Changes:

- Added currency field to payment responses
- Cognito authorization required
- Backward compatibility maintained

# API Versioning Notes

## Why version?

Avoid breaking existing clients.

## Example

V1:
{
payment_id,
amount,
client,
status
}

V2:
{
payment_id,
amount,
client,
status,
currency
}

## Key Lesson

Keep storage unchanged when possible.
Version API contracts, not necessarily databases.

---

# Docker Fundamentals

To prepare for Kubernetes and modern backend deployment workflows, a dedicated Docker learning section was introduced.

The Docker examples are intentionally isolated under:

learning/
└── docker-experiments/

These exercises focus on understanding Docker concepts before integrating containerization into production services.

## Topics Covered

- Docker Images
- Docker Containers
- Dockerfiles
- Multi-stage Builds
- Docker Compose
- Volumes
- Bind Mounts
- Environment Variables
- Networking
- Redis Containers
- Background Worker Containers
- Logging
- Image Layer Caching

## Purpose

The Docker learning environment is separate from the primary AWS serverless project.

Once sufficient proficiency is reached, Docker concepts will be applied directly to future platform services.


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
- API Gateway Resources
- API Gateway Methods
- API Gateway Integrations
- API Gateway Deployments
- API Gateway Stages
- Lambda Proxy Integration
- DynamoDB Scan vs GetItem
- CloudWatch-Based Debugging
- Least Privilege IAM Design
- Metrics vs Logs
- CloudWatch Alarms
- Thresholds
- Evaluation Periods
- Monitoring Production Failures
- Deployment snapshots
- API versioning
- Backward compatibility
- Contract evolution

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

### Completed Milestones

- Terraform Infrastructure as Code
- Remote State Backend with Locking
- Serverless Data Ingestion Pipeline
- GitHub Actions CI Pipeline
- GitHub Actions CD Pipeline
- OIDC Authentication Between GitHub and AWS
- Branch Protection and Deployment Gates
- SQS Dead Letter Queue (DLQ)
- Lambda Failure Handling and Retry Policies
- CloudWatch Monitoring and Error Tracing
- CSV Aggregation and Reporting
- Authentication and Authorization
- API Versioning
- Event-Driven Payment Processing
- SQS Queue Integration
- Lambda Worker Processing
- Docker Fundamentals
- Docker Compose
- Redis Container Integration
- Background Worker Container
- Multi-stage Docker Builds

## Next Milestones

### Foundation

- Java Fundamentals Refresh
- Spring Boot Fundamentals
- Spring REST APIs
- Spring Data JPA
- Spring Security

### Platform Evolution

- Repository Architecture
- Monorepo Organization
- Fleet Platform Design
- Domain Modeling

### Cloud Native

- Kubernetes Fundamentals
- Service Deployment
- Container Orchestration
- Observability
- Metrics and Logging

### AWS

- SNS Event Notifications
- DynamoDB Streams
- Event-Driven Expansion

## Long-Term Vision

This repository began as a focused AWS Serverless learning project.

As additional technologies are learned, the repository will gradually evolve into a larger cloud-native backend platform.

Planned technologies include:

- Java
- Spring Boot
- Docker
- Kubernetes
- Redis
- PostgreSQL
- Distributed Services
- Observability

The long-term objective is to build a production-inspired telemetry platform capable of processing fleet data, managing customers, handling billing, and demonstrating modern cloud-native architecture.
