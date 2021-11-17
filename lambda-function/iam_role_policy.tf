resource "aws_iam_policy" "quizwizard_api_logstream_policy" {
  
  name = "quizwizard_api_lambda_policy"
  path = "/"
  description = "IAM policy for quizwizard API"
  policy = data.aws_iam_policy_document.lambda_policies.json
  tags = merge(
    var.default_tags,
    {
      Workspace = terraform.workspace
    },
  )
}


data "aws_iam_policy_document" "lambda_policies" {
dynamic "statement" {
    for_each = var.lambda_functions
    iterator = role
    content {
      effect = "Allow"
      resources = ["arn:aws:logs:${var.aws_region}:${var.aws_account}:log-group:/aws/lambda/${role.value}:*"]     
             
      actions = ["logs:CreateLogStream","logs:PutLogEvents"]
      
    }
  }


}


data "aws_iam_policy" "SecretManagerReadWriteAccess" {
  arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

data "aws_iam_policy" "ExecuteOtherLambda" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaRole"
}



resource "aws_iam_role" "quizwizard_api_role" {
  name = "quizwizard_api_role"
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
  tags = merge(
    var.default_tags,
    {
      Workspace = terraform.workspace
    }
  )
}

resource "aws_iam_role_policy_attachment" "lambda_role_policy" {
  role = aws_iam_role.quizwizard_api_role.name
  policy_arn = aws_iam_policy.quizwizard_api_logstream_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_role_policy_secretmanager" {
  role = aws_iam_role.quizwizard_api_role.name
  policy_arn = data.aws_iam_policy.SecretManagerReadWriteAccess.arn
}

resource "aws_iam_role_policy_attachment" "lambda_role_policy_executeotherlambda" {
  role = aws_iam_role.quizwizard_api_role.name
  policy_arn = data.aws_iam_policy.ExecuteOtherLambda.arn
}
