resource "tls_private_key" "test_servers_key" {
  algorithm = "RSA"
  rsa_bits  = 2048

}
resource "aws_key_pair" "test_servers_key" {
  key_name   = "test_servers_key"
  public_key = "${tls_private_key.test_servers_key.public_key_openssh}"
}

resource "local_file" "test_servers_key" {
  sensitive_content = "${tls_private_key.test_servers_key.private_key_pem}"
  filename           = "test_servers.pem"
}

resource "local_file" "test_servers_key_pub" {
  sensitive_content = "${tls_private_key.test_servers_key.public_key_openssh}"
  filename           = "test_servers.pub"
}



