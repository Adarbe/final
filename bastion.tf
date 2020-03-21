# resource "aws_instance" "bastion" {
#   count = 1
#   ami = "ami-024582e76075564db"
#   instance_type = "t2.micro"
  
#   key_name = aws_key_pair.jenkins_ec2_key.key_name
#   tags = {
#     Name = "bastion ${count.index}"
#   }


#   resource "aws_key_pair" "jenkins_ec2_key" {
#   key_name = "terraform_ec2_key"
#   public_key = file("jenkins_ec2_key.pub")
# }
#   connection {
#     type = "ssh"
#     host = "self.public_ip"
#     private_key = key_name = aws_key_pair.jenkins_ec2_key.key_name
#     user = "ubuntu"
#   }
#   availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
#   subnet_id = "${data.aws_subnet.private[count.index].id}"
# #  vpc_security_group_ids = 
# }