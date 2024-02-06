resource "aws_instance" "instance" {
  ami = "ami-0ecb0bb5d6b19457a"
  instance_type               = "t2.micro"
  availability_zone           = "us-west-2a"
  associate_public_ip_address = true
  key_name                    = "vockey"
  vpc_security_group_ids      = ["sg-0d35a1ad035ddd11e"]
  subnet_id                   = "subnet-019029a0fc446f8dc"
#  iam_instance_profile        = "LabRole"
  count = 1
  tags = {
    Name = "Sandbox"
  }
}