variable "AWS_ACCESS_KEY_ID" {}
variable "AWS_SECRET_ACCESS_KEY" {}
variable "aws_region" {
      default = "us-east-1"
}


resource "tls_private_key" "servers" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "servers" {
  key_name   = "servers"
  public_key = "${tls_private_key.servers.public_key_openssh}"
}

resource "local_file" "servers" {
sensitive_content = "${tls_private_key.servers.private_key_pem}"
  filename           = "servers.pem"
}
resource "tls_private_key" "slave" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "slave" {
  key_name   = "slave"
  public_key = "${tls_private_key.slave.public_key_openssh}"
}

resource "local_file" "slave" {
sensitive_content = "${tls_private_key.slave.private_key_pem}"
  filename           = "slave.pem"
}


variable "pri_subnet" {
	type = "list"
	default = ["10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
}
variable "pub_subnet" {
	type = "list"
	default = ["10.0.20.0/24", "10.0.30.0/24", "10.0.40.0/24"]
}
variable "network_address_space" {
  default = "10.0.0.0/16"
}

variable "azs" {
  description = "A list of availability zones in the region"
  type        = list(string)
  default     = []
}


variable "jenkins_master_port" {
  description = "The Port of the master jenkins instance"
  default = 8080
}

variable "plugins" {
  type        = list(string)
  description = "A list of Jenkins plugins to install, use short names."
  default     = ["git", "pipeline", "SSH Slaves", "Build Monitor View","GreenBalls", "Blue Ocean", "Slack Notifications", "GitHub Plugin", "Kubernetes"]
}


variable "jnlp_port" {
  description = "The Port to use for Jenkins master to slave communication bewtween instances"
  default     = 49187
}


variable "jenkins_image_name"{
  description = "Jenkins image name"
  default = "jenkins"
}

variable "jenkins_image_tag"{
  description = "jenkins image tag"
  default = "latest"
}

variable "vpc_security_group_ids" {
  description = "final default security group"
  default = "default"
}
