lambda_functions = {
  notify_new_record = {
    source_path = "../../lambda/notify-new-record.py"
    handler     = "notify-new-record.lambda_handler"
    runtime     = "python3.11"
    role_arn    = "arn:aws:iam::123456789012:role/lambda-exec-role"
  },
  purchase_capacity_block = {
    source_path = "../../lambda/purchase-capacity-block.py"
    handler     = "purchase-capacity-block.lambda_handler"
    runtime     = "python3.11"
    role_arn    = "arn:aws:iam::123456789012:role/lambda-exec-role"
  },
  return_task_token = {
    source_path = "../../lambda/return-task-token.py"
    handler     = "return-task-token.lambda_handler"
    runtime     = "python3.11"
    role_arn    = "arn:aws:iam::123456789012:role/lambda-exec-role"
  },
  send_approval_email = {
    source_path = "../../lambda/send-approval-email.py"
    handler     = "send-approval-email.lambda_handler"
    runtime     = "python3.11"
    role_arn    = "arn:aws:iam::123456789012:role/lambda-exec-role"
  },
  set_request_status = {
    source_path = "../../lambda/set-request-status.py"
    handler     = "set-request-status.lambda_handler"
    runtime     = "python3.11"
    role_arn    = "arn:aws:iam::123456789012:role/lambda-exec-role"
  },
  submit_approval_request = {
    source_path = "../../lambda/submit-approval-request.py"
    handler     = "submit-approval-request.lambda_handler"
    runtime     = "python3.11"
    role_arn    = "arn:aws:iam::123456789012:role/lambda-exec-role"
  }
}
