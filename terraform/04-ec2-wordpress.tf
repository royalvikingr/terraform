/* # Set local values???
locals {
  # The name of the EC2 instance
  name = "deham10-wordpress"
  owner = "sp"
} */

# Select the newest AMI
data "aws_ami" "latest_linux_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*x86_64"]
  }
}

# Create an EC2 instance
resource "aws_instance" "deham10-wp-instance" {
  ami = var.AMI[var.AWS_REGION]
  instance_type = "t2.micro"
  availability_zone = "us-west-2a"
  associate_public_ip_address = true
  key_name = "vockey"
  vpc_security_group_ids = [aws_security_group.deham10-wordpress-sg.id]
  subnet_id = aws_subnet.public-1
  #iam_instance_profile = "LabRole"
  count = 1
  tags = {
    Name = "deham10-wp-instance"
  }
  #user_data = file("userdata.sh")
  user_data = "${base64encode(data.template_file.ec2userdatatemplate.rendered)}"

  provisioner "local-exec" {
    command = "echo Instance Type = ${self.instance_type}, Instance ID = ${self.id}, Public IP = ${self.public_ip}, AMI ID = ${self.ami} >> metadata"
  }
}

data "template_file" "ec2userdatatemplate" {
  template = "${file("04a-wp-userdata.tpl")}"
}

output "ec2rendered" {
  value = "${data.template_file.ec2userdatatemplate.rendered}"
}

output "public_ip" {
  value = aws_instance.instance[0].public_ip
}