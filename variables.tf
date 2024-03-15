variable "key-name" {
  default = "vockey"
}

variable "aws-region" {
  default     = "us-west-2"
  description = "AWS Region"
}

variable "pub-cidr" {
  default = "0.0.0.0/0"
}

/* # AMI variable obsolete b/c we can fetch it
variable "AMI" {
  type = map(string)
  description = "Region specific AMI"
  default = {
    us-east-1 = "ami-0230bd60aa48260c6"
    eu-central-1 = "ami-0ec8c354f85e48227"
    us-west-2 = "ami-052c9ea013e6e3567"
  }
} */