variable "lambda_configs" {
  type = map(string)
  default = {
    notify_new_record       = "notify_new_record.py"
    purchase_capacity_block = "purchase_capacity_block.py"
    return_task_token       = "return_task_token.py"
    set_request_status      = "set_request_status.py"
    submit_approval_request = "submit_approval_request.py"
  }
}
