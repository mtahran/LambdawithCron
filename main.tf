data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "lambda_basic_execution_role" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}
resource "aws_iam_role" "iam_for_lambda_1" {
  name               = "iam_for_lambda_1"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy" "lambda_execution_1" {
  #Provides write permissions to CloudWatch Logs
  name   = "basic_lambda_execution"
  role   = aws_iam_role.iam_for_lambda_1.id
  policy = data.aws_iam_policy_document.lambda_basic_execution_role.json
}


# data "archive_file" "zip_the_python_code" {
#   type        = "zip"
#   source_file = "${path.module}/App/Hello-World.py"
#   output_path = "${path.module}/App/Hello-World.zip"
# }

resource "aws_lambda_function" "cron_lambda" {
  function_name = "cron_lambda"
  # filename      = "${path.module}/App/Hello-World.zip"
  role      = aws_iam_role.iam_for_lambda_1.arn
  handler   = "Hello-World.lambda_handler"
  s3_bucket = var.s3_bucket
  s3_key    = var.s3_key
  runtime   = "python3.10"

  tags = merge({
    Name = "${var.env}-lf"
  }, local.common_tags)
}


# Create an EventBridge rule and Event Target to trigger Lambda Function
resource "aws_cloudwatch_event_rule" "cron_job" {
  name                = "Hello-World"
  description         = "Hello-World"
  schedule_expression = "cron(0/5 * * * ? *)"
  event_pattern = jsonencode({
    detail-type = [
      "My Lambda Function"
    ]
  })

  tags = merge({
    Name = "${var.env}-eb_rule"
  }, local.common_tags)
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule      = aws_cloudwatch_event_rule.cron_job.name
  target_id = "SendToLambdaFunction"
  arn       = aws_lambda_function.cron_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cron_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cron_job.arn
}