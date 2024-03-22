# Create VPC to launch instances into
resource "aws_vpc" "royal-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "royal-vpc"
  }
}

# Create subnets
resource "aws_subnet" "public-1" {
  vpc_id                  = aws_vpc.royal-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "royal-pubnet1"
  }
}

resource "aws_subnet" "private-1" {
  vpc_id            = aws_vpc.royal-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2a"
  tags = {
    Name = "royal-privnet1"
  }
}

resource "aws_subnet" "public-2" {
  vpc_id                  = aws_vpc.royal-vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "royal-pubnet2"
  }
}

resource "aws_subnet" "private-2" {
  vpc_id            = aws_vpc.royal-vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-west-2b"
  tags = {
    Name = "royal-privnet2"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  # attach the igw to the following vpc
  vpc_id = aws_vpc.royal-vpc.id
  tags = {
    Name = "royal-igw"
  }
}

/* # Allocate Elastic IP for NAT Gateway ###Whey I destroy, will it be released?
resource "aws_eip" "royal-nat-eip" {
  vpc = true
} */

/* # Create a NAT Gateway for the private subnet(s) to access the internet
resource "aws_nat_gateway" "royal-nat-gw" {
  allocation_id = aws_eip.royal-nat-eip.id
  subnet_id     = aws_subnet.public-1.id # Reference public subnet ID
  tags = {
    Name = "royal-nat-gw"
  }
} */

# Create a route table for Public Subnet
resource "aws_route_table" "royal-pub-rtb" {
  vpc_id = aws_vpc.royal-vpc.id
  route {
    cidr_block = var.pub-cidr
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "royal-pub-rtb"
  }
}

# Create a Route Table for Private Subnet(s); currently connecting to igw b/c no nat-gw
resource "aws_route_table" "royal-priv-rtb" {
  vpc_id = aws_vpc.royal-vpc.id
  /* route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  } */
  tags = {
    Name = "royal-priv-rtb"
  }
}

# Associate the public route table with public subnet 1
resource "aws_route_table_association" "pubnet1-asso" {
  route_table_id = aws_route_table.royal-pub-rtb.id
  subnet_id      = aws_subnet.public-1.id
  depends_on     = [aws_route_table.royal-pub-rtb, aws_subnet.public-1]
}

# Associate the private route table with private subnet 1
resource "aws_route_table_association" "privnet1-asso" {
  route_table_id = aws_route_table.royal-priv-rtb.id
  subnet_id      = aws_subnet.private-1.id
  depends_on     = [aws_route_table.royal-priv-rtb, aws_subnet.private-1]
}

# Associate the public route table with public subnet 2
resource "aws_route_table_association" "pubnet2-asso" {
  route_table_id = aws_route_table.royal-pub-rtb.id
  subnet_id      = aws_subnet.public-2.id
  depends_on     = [aws_route_table.royal-pub-rtb, aws_subnet.public-2]
}

# Associate the private route table with private subnet 2
resource "aws_route_table_association" "privnet2-asso" {
  route_table_id = aws_route_table.royal-priv-rtb.id
  subnet_id      = aws_subnet.private-2.id
  depends_on     = [aws_route_table.royal-priv-rtb, aws_subnet.private-2]
}