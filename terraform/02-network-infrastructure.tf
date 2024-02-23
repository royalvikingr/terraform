# Create VPC to launch instances into
resource "aws_vpc" "dev_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags       =  {
    name     = "deham10-vpc"
  }
}

# Create subnets
resource "aws_subnet" "public-1" {
  vpc_id     = aws_vpc.dev_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "deham10-pubnet1"
  }
}

resource "aws_subnet" "private-1" {
  vpc_id     = aws_vpc.dev_vpc.id 
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-2a"
  tags = {
    Name = "deham10-privnet1"
  }
}

resource "aws_subnet" "public-2" {
  vpc_id     = aws_vpc.dev_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-west-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "deham10-pubnet2"
  }
}

resource "aws_subnet" "private-2" {
  vpc_id     = aws_vpc.dev_vpc.id 
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-west-2b"
  tags = {
    Name = "deham10-privnet2"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  # attach the igw to the following vpc
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    Name  = "deham10-igw"
  }
}
# Allocate Elastic IP for NAT Gateway
#resource "aws_eip" "nat_eip" {
#  vpc = true
#}

# Create a NAT Gateway for the private subnet(s) to access the internet
#resource "aws_nat_gateway" "nat" {
#  allocation_id = aws_eip.nat_eip.id
#  subnet_id = aws_subnet.public-1.id # Reference public subnet ID
#  tags = {
#    Name = "nat-gw" 
#  }
#}

# Create a Route Table for Public Subnet
resource "aws_route_table" "RB_Public_RouteTable" {
  vpc_id = aws_vpc.dev_vpc.id
  route {
    cidr_block = var.CIDR_BLOCK
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "deham10-pubrt"
  }
}

# Create a Route Table for Private Subnet(s)
resource "aws_route_table" "RB_Private_RouteTable" {
  vpc_id = aws_vpc.dev_vpc.id
  route { 
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "deham10-privrt"
  }
}

# Associate the public route table with public subnet 1
resource "aws_route_table_association" "Public_Subnet1_Asso" {
  route_table_id = aws_route_table.RB_Public_RouteTable.id
  subnet_id      = aws_subnet.public-1.id
  depends_on     = [aws_route_table.RB_Public_RouteTable, aws_subnet.public-1]
}

# Associate the private route table with private subnet 1
resource "aws_route_table_association" "Private_Subnet1_Asso" {
  route_table_id = aws_route_table.RB_Private_RouteTable.id
  subnet_id      = aws_subnet.private-1.id
  depends_on     = [aws_route_table.RB_Private_RouteTable, aws_subnet.private-1]
}

# Associate the public route table with public subnet 2
resource "aws_route_table_association" "Public_Subnet2_Asso" {
  route_table_id = aws_route_table.RB_Public_RouteTable.id
  subnet_id      = aws_subnet.public-2.id
  depends_on     = [aws_route_table.RB_Public_RouteTable, aws_subnet.public-2]
}

# Associate the private route table with private subnet 2
resource "aws_route_table_association" "Private_Subnet2_Asso" {
  route_table_id = aws_route_table.RB_Private_RouteTable.id
  subnet_id      = aws_subnet.private-2.id
  depends_on     = [aws_route_table.RB_Private_RouteTable, aws_subnet.private-2]
}