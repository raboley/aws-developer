
locals {
  # This is a local because by default, portal will create origin ID with a syntax like this.
  media_origin_id = "S3-${aws_s3_bucket.i.id}"
}
#### Cloud front
resource "aws_cloudfront_distribution" "i" {
  enabled         = true
  is_ipv6_enabled = true

  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]
    cached_methods = [
      "GET",
      "HEAD",
    ]
    target_origin_id       = local.media_origin_id
    viewer_protocol_policy = "allow-all"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }
  origin {
    domain_name = aws_s3_bucket.i.bucket_domain_name
    origin_id   = local.media_origin_id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.i.cloudfront_access_identity_path
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_cloudfront_origin_access_identity" "i" {
  comment = "terraform-cloudfront-identity"
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.i.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.i.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "i" {
  bucket = aws_s3_bucket.i.id
  policy = data.aws_iam_policy_document.s3_policy.json
}