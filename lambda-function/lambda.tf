locals {
  environment_map = var.env_props == null ? [] : [var.env_props]
}

data "archive_file" "quizwizard_api_lambdas" {
  count    = length(var.lambda_functions)
  type        = "zip"
  source_file = "${var.lambda_functions[count.index]}.py"
  output_path = "${var.lambda_functions[count.index]}.zip"
}



resource "aws_cloudwatch_log_group" "quizwizard_api_lambda" {
  count    = length(var.lambda_functions)
  name              = "/aws/lambda/${var.lambda_functions[count.index]}"
  retention_in_days = 30
  tags = merge(
    var.default_tags,
    {
      Workspace = terraform.workspace
    }
  )
}


resource "aws_lambda_function" "quizwizard_api_lambdas" {
  count    = length(var.lambda_functions)
  filename = data.archive_file.quizwizard_api_lambdas[count.index].output_path
  function_name = var.lambda_functions[count.index]
  role = aws_iam_role.quizwizard_api_role.arn
  handler = "lambda_function.lambda_handler"
  runtime = "python3.9"
  timeout = 100
  publish = true
  source_code_hash = data.archive_file.quizwizard_api_lambdas[count.index].output_base64sha256
  # dynamic "environment" {
  #   for_each = local.environment_map
  #   content {
  #     variables = environment.value
  #   }
  # }

  tags = merge(
    var.default_tags,
    {
      Workspace = terraform.workspace
    }
  )
  lifecycle {
    ignore_changes = [tags]
  }
  
}


resource "aws_lambda_alias" "quiz_lambda_alias" {
  count    = length(var.lambda_functions)
  name             = "quiz_alias"
  description      = "Alias for the quiz apo"
  function_name    = aws_lambda_function.quizwizard_api_lambdas[count.index].arn
  function_version = "$LATEST"

#  routing_config {
#    additional_version_weights = {
#      "2" = 0.5
#    }
#  }
}