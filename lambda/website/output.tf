output "lambda_base_url" {
  value = aws_api_gateway_deployment.example.invoke_url
}

output "static_website_url" {
  value = "http://${aws_s3_bucket.website.website_endpoint}"
}