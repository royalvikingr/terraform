# Create a Security Group to allow HTTP
resource "aws_security_group" "allow-http" {
  name        = "allow-http"
  description = "allow HTTP"
  vpc_id      = aws_vpc.royal-vpc.id

  # Add inbound rules
  # Add a rule for HTTP
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.pub-cidr]
  }

  # Add a rule for HTTPS; deactivated b/c no cert
  /* ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.pub-cidr]
  } */

  # Add a rule for SSH; deactivated b/c different sg
  /* ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.pub-cidr]
  } */

  # Add an outbound rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.pub-cidr]
  }
  tags = {
    Name = "allow-http"
  }
}

# Create a Security Group to allow SSH
resource "aws_security_group" "allow-ssh" {
  name        = "allow-ssh"
  description = "Allow SSH traffic"
  vpc_id      = aws_vpc.royal-vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.pub-cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.pub-cidr]
  }

  tags = {
    Name = "allow-ssh"
  }
}

/* # Create a Security Group to allow EC2 to Aurora MySQL
resource "aws_security_group" "allow_ec2_aurora" {
  name        = "allow_ec2_aurora"
  description = "Allow EC2 to Aurora traffic"
  vpc_id      = aws_vpc.royal-vpc.id

  ingress {
    description      = "allow ec2 to aurora"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.pub-cidr]
  }

  egress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = [var.pub-cidr]
  }

  tags = {
    Name = "allow_ssh"
  }
} */

/* # Create a Security Group to allow Aurora to MySQL
resource "aws_security_group" "allow_aurora_access" {
  name        = "allow_aurora_access"
  description = "Allow EC2 to aurora"
  vpc_id = aws_vpc.royal-vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.pub-cidr]
    # security_groups = [aws_security_group.allow_ssh.id] ???
  }

  tags = {
    Name = "aurora-stack-allow-aurora-MySQL"
  }
} */