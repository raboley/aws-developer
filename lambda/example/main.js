'use strict'

exports.handler = function (event, context, callback) {
  var response = {
    statusCode: 200,
    headers: {
      'Content-Type': 'text/html; charset=utf-8',
    },
    body: '<p>Hello world!</p>',
  }
  callback(null, response)
}

// aws s3api create-bucket --bucket=terraform-serverless-example-sladkjf --region=us-east-1

// aws s3 cp example.zip s3://terraform-serverless-example-sladkjf/v1.0.0/example.zip