locals {
  jenkins_default_name = "jenkins"
  jenkins_home = "/home/ubuntu/jenkins_home"
  jenkins_home_mount = "${local.jenkins_home}:/var/jenkins_home"
  docker_sock_mount = "/var/run/docker.sock:/var/run/docker.sock"
  java_opts = "JAVA_OPTS='-Djenkins.install.runSetupWizard=false'"
  jenkins_master_url = "http://${aws_instance.jenkins_master.public_ip}:8080"
}


resource "tls_private_key" "jenkins_master" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "jenkins_master" {
  key_name   = "jenkins_master"
  public_key = "${tls_private_key.jenkins_master.public_key_openssh}"
}


resource "aws_instance" "jenkins_master" {
#######################################################
# description = "create EC2 machine for jenkins master"
#######################################################
  ami = "ami-07d0cf3af28718ef8"
  instance_type = "t3.micro"
  key_name = aws_key_pair.servers_key.key_name
  tags = {
    Name = "Jenkins_Master-1"
  }
  vpc_security_group_ids =["${aws_security_group.default.id}","${aws_security_group.jenkins-final.id}"]
  subnet_id = "${aws_subnet.pubsub[1].id}"
  connection {
    type = "ssh"
    host = "${aws_instance.jenkins_master.public_ip}"
    user = "ubuntu"
    private_key = tls_private_key.servers_key.private_key_pem
  }
  
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt install docker.io -y",
      "sudo systemctl start docker",
      "sudo systemctl enable docker",
      "sudo usermod -aG docker ubuntu",
      "mkdir -p ${local.jenkins_home}",
      "sudo chown -R 1000:1000 ${local.jenkins_home}",
    ]
  }
  provisioner "file" {
    source = "/Users/adarb/projects/final/Dockerfile"
    destination = "/home/ubuntu/Dockerfile" 
  }
  provisioner "file" {
    source = "/Users/adarb/projects/final/plugins.txt"
    destination = "/home/ubuntu/plugins.txt" 
  }

provisioner "remote-exec" {
    inline = [
      "docker build -t myjenkins:01 .",
      "sudo docker run -d -p 8080:8080 -p 50000:50000 -v ${local.jenkins_home_mount} -v ${local.docker_sock_mount} --env ${local.java_opts} myjenkins:01"
   ]
  }
}

resource "aws_instance" "jenkins_slave" {
#########################################################
# description = "create 3 EC2 machines for jenkins slave"
#########################################################
  count = "${length(var.pub_subnet)}"
  ami = "ami-00068cd7555f543d5"
  instance_type = "t2.micro"
  key_name = "${var.default_slaves_keypair_name}"
  associate_public_ip_address = true
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  subnet_id = "${aws_subnet.pubsub[count.index].id}"
  vpc_security_group_ids =["${aws_security_group.default.id}","${aws_security_group.jenkins-final.id}"]
  tags = {
    Name = "jenkins_slave-${count.index+1}"
    Labels = "linux"
  }
  connection {
    type = "ssh"
    host = "${self.public_ip}"
    private_key = "${file("slaves_key.pem")}"
    user = "ec2-user"
  }
  user_data = <<-EOF
            #! /bin/bash
            sudo yum update -y
            sudo yum install java-1.8.0 -y
            sudo alternatives --install /usr/bin/java java /usr/java/latest/bin/java 1 -y
            sudo yum install docker git -y
            sudo service docker start
            sudo usermod -aG docker ec2-user
            sudo chown -R jenkins:jenkins /var/lib/jenkins/
            sudo yum install epel-release -y
            sudo yum install python-pip -y
            sudo pip install awscli
            sudo yum install git -y
            sudo chmod 777 /var/lib/jenkins/
EOF
}