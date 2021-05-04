resource "random_string" "i" {
  length  = 5
  special = false
  upper   = false
}

resource "aws_s3_bucket" "website" {
  bucket        = "solution-architect-media-${random_string.i.result}"
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name = "website"
  }
}



resource "aws_s3_bucket_policy" "i" {
  bucket = aws_s3_bucket.website.id
  policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:GetObject"
        ],
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.website.id}/*"
        ]
    }
  ]
}
EOF
}

// Objects uploaded to S3 can be anywhere from 0KB -> 5GB in size.
resource "aws_s3_bucket_object" "index" {
  bucket       = aws_s3_bucket.website.bucket
  key          = "index.html"
  acl          = "public-read"
  content_type = "text/html"

  // Since this file has to be dynamic, ex. have the lambda url, This function will substitute the lambda_url variable
  // with the api gateway url endpoint mapped to our lambda.
  content = templatefile("${path.module}/site/index.html", { lambda_url = aws_api_gateway_deployment.example.invoke_url })

  etag = filemd5("${path.module}/site/index.html")
}

// Objects uploaded to S3 can be anywhere from 0KB -> 5GB in size.
resource "aws_s3_bucket_object" "error" {
  bucket       = aws_s3_bucket.website.bucket
  key          = "error.html"
  source       = "${path.module}/site/error.html"
  acl          = "public-read"
  content_type = "text/html"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("${path.module}/site/error.html")
}