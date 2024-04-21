output "Lambda_Arn" {
  description = "Amazon Resource Name (ARN) identifying your Lambda Function"
  value       = aws_lambda_function.cron_lambda.arn
}

output "Lambda_invoke_arn" {
  description = "ARN to be used for invoking Lambda Function from API Gateway"
  value       = aws_lambda_function.cron_lambda.invoke_arn
}

output "eventbridge_arn" {
  description = "ARN of the EventBridge Rule"
  value       = aws_cloudwatch_event_rule.cron_job.arn
}