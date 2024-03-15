terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws-region
}

# Fetch the newest AMI
data "aws_ami" "latest-linux-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*x86_64"]
  }
}

# Define userdata template file
data "template_file" "ec2userdatatemplate" {
  template = file("wp-userdata.tpl")
}