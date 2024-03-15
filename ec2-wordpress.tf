/* # Set local values???
locals {
  # The name of the EC2 instance
  name = "wordpress-ec2"
  owner = "sp"
} */
/* deactivated b/c ASG exists
# Create an EC2 instance
resource "aws_instance" "wp-instance" {
  ami                         = data.aws_ami.latest_linux_ami.id
  instance_type               = "t2.micro"
  availability_zone           = "us-west-2a"
  associate_public_ip_address = true
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.wordpress-sg.id]
  subnet_id                   = aws_subnet.public-1.id
  #iam_instance_profile         = "LabRole"
  count = 1
  tags = {
    Name = "royal-wp-instance"
  }
  #user_data = file("userdata.sh")
  user_data = base64encode(data.template_file.ec2userdatatemplate.rendered)

  provisioner "local-exec" {
    command = "echo Instance Type = ${self.instance_type}, Instance ID = ${self.id}, Public IP = ${self.public_ip}, AMI ID = ${self.ami} >> metadata"
  }
}

output "ec2rendered" {
  value = data.template_file.ec2userdatatemplate.rendered
}

output "public_ip" {
  value = aws_instance.wp-instance[0].public_ip
}
 */