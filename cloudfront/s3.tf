variable "region" {
 default = "ap-southeast-2"
}

provider "aws" {
  region = var.region
}

resource "random_string" "i" {
  length = 5
  special = false
  upper = false
}

resource "aws_s3_bucket" "i" {
  bucket = "my-cloudfront-${random_string.i.result}"
  acl = "private"
}

// Object is private, and can only be seen via the cloudfront distribution
resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.i.bucket
  key    = "reality.jpg"
  source = "RealityShowShow_Logo.jpg"
  acl = "private"
  content_type = "image/jpeg"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("RealityShowShow_Logo.jpg")
}
