terraform {
  required_version = ">= 1.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


resource "local_file" "hello" {
  filename = "hello.txt"
  content  = "This is an example message text"
}

resource "aws_s3_bucket" "demo" {
  bucket = "jsdev305-aws-serverless-pipeline-demo"
}

