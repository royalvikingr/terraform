# Create S3 bucket
/* resource "aws_s3_bucket" "royal-s3-bucket-666" {
  bucket = "royal-s3-bucket-666"
  tags = {
    Name = "royal-s3-bucket-666"
  }
} */

# Attach a bucket level policy to allow getting the object lock configuration
/* resource "aws_s3_bucket_policy" "royal-s3-bucket-policy-666" {
  bucket = aws_s3_bucket.royal-s3-bucket-666.id
  policy = data.aws_iam_policy_document.royal-s3-bucket-policy-666.json
} */

/* data "aws_iam_policy_document" "royal-s3-bucket-policy-666" {
  statement {
    sid = "AllowGetObjectLockConfiguration"
    actions = [
      "s3:GetObjectLockConfiguration"
    ]
    resources = [
      aws_s3_bucket.royal-s3-bucket-666.arn
    ]
    effect = "Allow"
  }
} */

/* data "aws_iam_policy_document" "royal-s3-bucket-policy-666" {
  statement {
    sid = "AllowGetBucketObjectLockConfiguration"
    actions = [
      "s3:GetBucketObjectLockConfiguration"
    ]
    resources = [
      aws_s3_bucket.royal-s3-bucket-666.arn
    ]
    effect = "Allow"
  }
} */