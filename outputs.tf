output "cost_notfier_lambda_name" {
  description = "Created lambda's name"
  value       = module.billing_notifier_lambda.lambda_function.function_name
}

variable "test-variable" {
  
}