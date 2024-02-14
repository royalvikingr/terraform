# Create a VPC to launch our instances into
resource "aws_vpc" "dev_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags       =  {
    name     = "deham10"
  }
}
resource "aws_internet_gateway" "cpstn_IGW"{
  # attach the igw to the following vpc
  vpc_id                 = aws_vpc.dev_vpc.id
  tags                   = {
      Name               = "cpstn_vpc_igw"
  }
}