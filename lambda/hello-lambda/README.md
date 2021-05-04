# Lambda

A repo saving some lambda configurations.

Lambda's require you to build a code zip file prior to deploying them. This repo accomplishes that
via a Makefile

## Terraform apply

There is a two step process to apply

```shell
# step 1: build the code artifact
cd lambda
make build

# step 2: terraform apply
terraform init
terraform apply
```

you can then test the app using the aws cli

```shell
aws lambda invoke --region=us-east-1 --function-name=ServerlessExample output.txt
```

The full output will be shown in the output.txt, but in the terminal you should get something like:

```shell
# terminal output (Not the output.txt file)
{
    "StatusCode": 200,
    "ExecutedVersion": "$LATEST"
}
```

If you didn't, make sure your zip file is just the main.js file, and no extra folders, etc.