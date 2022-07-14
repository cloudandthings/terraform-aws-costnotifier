output "cost_notfier_lambda_name" {
  value = module.billing_notifier_lambda.lambda_function.function_name
}
