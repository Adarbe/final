

output "public_ip_jenkins_master"  {
value = "${aws_instance.jenkins_master.public_ip}"
}

output "private_ip" {
  value = "${aws_instance.jenkins_master.private_ip}"
}


output "public_ip_jenkins_slave"  {
value = "${aws_instance.jenkins_slave.*.public_ip}"
}

output "jenkins_slaves_private_IP" {
    value = "${aws_instance.jenkins_slave.*.private_ip}"
}