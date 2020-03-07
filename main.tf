

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

# resource "tls_private_key" "servers" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }
# resource "aws_key_pair" "servers" {
#   key_name   = "servers"
#   public_key = "${tls_private_key.servers.public_key_openssh}"
# }

# resource "local_file" "servers" {
# sensitive_content = "${tls_private_key.servers.private_key_pem}"
#   filename           = "servers.pem"
# }
# resource "tls_private_key" "slave" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }
# resource "aws_key_pair" "slaves" {
#   key_name   = "slave"
#   public_key = "${tls_private_key.slave.public_key_openssh}"
# }

# resource "local_file" "slaves" {
# sensitive_content = "${tls_private_key.slave.private_key_pem}"
#   filename           = "slave.pem"
#}
