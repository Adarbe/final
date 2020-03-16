
provider "aws" {
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  region = "us-east-1"
}

#######Resource####

resource "aws_vpc" "final-project" {
  cidr_block       = "10.0.0.0/16"
  tags = {
    Name = "final-project"
  }
  enable_dns_hostnames = true
  enable_dns_support   = true
}

data "aws_availability_zones" "available" {}



