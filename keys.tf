resource "tls_private_key" "servers_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "servers_key" {
  key_name = "server_key"
  public_key = "${tls_private_key.servers_key.public_key_openssh}" 
}

resource "local_file" "servers_key" {
  sensitive_content = "${tls_private_key.servers_key.private_key_pem}"
  filename           = "servers_key.pem"
}

resource "local_file" "servers_key_pub" {
  sensitive_content = "${tls_private_key.servers_key.public_key_openssh}"
  filename           = "servers_key.pub"
}



resource "tls_private_key" "slaves_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
resource "aws_key_pair" "slaves_key" {
  key_name   = "slaves_key"
  public_key = "${tls_private_key.slaves_key.public_key_openssh}"
}

resource "local_file" "slaves_key" {
sensitive_content = "${tls_private_key.slaves_key.private_key_pem}"
  filename           = "slaves_key.pem"
}
resource "local_file" "slaves_key_pub" {
  sensitive_content = "${tls_private_key.slaves_key.public_key_openssh}"
  filename           = "slaves_key.pub"
}

