# Create S3 bucket
resource "aws_s3_bucket" "royal-s3-bucket-666" {
  bucket = "royal-s3-bucket-666"
  tags = {
    Name = "royal-s3-bucket-666"
  }
}