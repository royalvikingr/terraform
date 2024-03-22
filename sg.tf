# Create a Security Group to allow HTTP
resource "aws_security_group" "allow-http" {
  name        = "allow-http"
  description = "allow HTTP"
  vpc_id      = aws_vpc.royal-vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
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
    Name = "allow-http"
  }
}

# Create a Security Group to allow HTTPS; deactivated b/c no cert
/* resource "aws_security_group" "allow-https" {
  name        = "allow-https"
  description = "allow HTTPS"
  vpc_id      = aws_vpc.royal-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
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
    Name = "allow-https"
  }
} */

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

# Create a Security Group to allow MySQL
resource "aws_security_group" "allow-mysql" {
  name        = "allow-mysql"
  description = "allow MySQL"
  vpc_id      = aws_vpc.royal-vpc.id

  ingress {
    description     = "MySQL"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks     = [var.pub-cidr]
    security_groups = [aws_security_group.allow-ssh.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.pub-cidr]
  }

  tags = {
    Name = "allow-mysql"
  }
}