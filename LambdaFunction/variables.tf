variable "lambda_configs" {
  type = list(string)
  default = [
    "notify_new_record",
    "purchase_capacity_block",
    "return_task_token",
    "send_approval_email",
    "set_request_status",
    "submit_approval_request"
  ]
}
