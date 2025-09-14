variable "lambda_names" {
  type = list(string)
  default = [
    "notify_new_record_test",
    "purchase_capacity_block_test",
    "return_task_token_test",
    "send_approval_email_test",
    "set_request_status_test",
    "submit_approval_request_test"
  ]
}
