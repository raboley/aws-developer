output "cloudfront_image_url" {
  value = "https://${aws_cloudfront_distribution.i.domain_name}/${aws_s3_bucket_object.object.key}"
}