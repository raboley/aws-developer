terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

variable "region" {
  default = "us-east-1"
}
provider "aws" {
  region = var.region
}


resource "aws_dynamodb_table" "i" {
  name           = "ProductCatalog"
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "Id"

  attribute {
    name = "Id"
    type = "N"
  }

  tags = {
    Name = "product-catalog"
  }

  lifecycle {
    ignore_changes = ["read_capacity", "write_capacity"]
  }
}

resource "aws_dynamodb_table_item" "example" {
  count      = length(local.put_requests)
  table_name = aws_dynamodb_table.i.name
  hash_key   = aws_dynamodb_table.i.hash_key

  item = jsonencode(local.put_requests[count.index]["PutRequest"]["Item"])
}

// Indexing the list of put requests created by the file to get the format correct for the count.
locals {
  file_contents = file("items.json")
  file_json     = jsondecode(local.file_contents)
  put_requests  = tolist(local.file_json["ProductCatalog"])
  first_item    = local.put_requests[0]["PutRequest"]["Item"]

  first_item_final = jsonencode(local.first_item)
}

output "put_requests" {
  value = length(local.put_requests)
}

output "first_item_final" {
  value = local.first_item_final
}

output "query_command" {
  value = <<EOF
  # Run the command below to query the database and verify records exist! (hint press q to quit the results)
  aws dynamodb get-item --table-name ${aws_dynamodb_table.i.name} --region ${var.region} --key '{"Id":{"N":"403"}}'
EOF
}

//output "file_contents" {
//  value = local.file_contents
//}
//
//output "file_json" {
//  value = local.file_json
//}
