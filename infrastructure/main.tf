//create dynamodb table for lambda function to update
resource "aws_dynamodb_table" "cloud-resume-challenge-terra" {
  name = "cloud-resume-challenge-terra"
  billing_mode = "PROVISIONED"
  hash_key = "id"

  read_capacity = 1
  write_capacity = 1

  attribute {
    name = "id"
    type = "S"
  } 
  
}

resource "aws_dynamodb_table_item" "my_item"{
  table_name = aws_dynamodb_table.cloud-resume-challenge-terra.name
  hash_key = aws_dynamodb_table.cloud-resume-challenge-terra.hash_key
  
  item = jsonencode(
  {
    "id": {S = "0"},
    "views": {N = "0"}
  }
  )

}

//create lambda resource
resource "aws_lambda_function" "cloud-resume" {
    filename = data.archive_file.zip.output_path
    source_code_hash = data.archive_file.zip.output_base64sha256
    function_name = "cloud-resume"
    role = aws_iam_role.iam_for_lambda.arn
    handler = "func.lambda_handler"
    runtime = "python3.9"
}   

//create lambda role
resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

// policy for lambda role to update and read database
resource "aws_iam_policy" "iam_policy_for_resume_project" {
  name = "aws_iam_policy_for_terraform_resume_project_policy"
  path = "/"
  description = "AWS IAM Policy for managing the resume project role"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource" : "arn:aws:logs:*:*:*",
          "Effect" : "Allow"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "dynamodb:UpdateItem",
			      "dynamodb:GetItem",
            "dynamodb:PutItem"
          ],
          "Resource" : "arn:aws:dynamodb:us-west-2:*:table/cloud-resume-challenge-terra"
        },
      ]
    }
  )
}

// attach policy to lambda role
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.iam_policy_for_resume_project.arn
}

//upload python code
data "archive_file" "zip" {
    type = "zip"
    source_dir = "${path.module}/lambda/"
    output_path = "${path.module}/packedlambda.zip"
    
}

// add function url to trigger lambda function
resource "aws_lambda_function_url" "url1" {
  function_name = aws_lambda_function.cloud-resume.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins = ["https://www.mdownsresume.com"]
    allow_methods = ["*"]
    allow_headers = ["date", "keep-alive"]
    expose_headers = ["keep-alive", "date"]
    max_age = 86400
  }
}