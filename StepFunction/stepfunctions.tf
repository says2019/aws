#Get the lambda function been create
variable "pythonfunctionapparn"{
}

#Aws step function role
resource "aws_iam_role" "step_function_role"{
   name                = "cloudquickpocsstepfunction.role"
   assume_role_policy  = <<-EOF
   {
     "Version":"2012-10-17"
     "Statement":[
        {
          "Action": "sts:AssumeRole",
          "Principal":{
             "Service" : "states.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": "StepFunctionAssumeRole"

        }
     ]
   }
   EOF
}

#Aws Step Function role-assume_role_policy
resource "aws_iam_role_policy" "step_fucntion_policy"{
   name   = "cqcdstepfunctionrole-assume_role_policy"
   role   = aws_iam_role.step_function_role.id

   policy = <<- EOF
   {
     "Version": "2012-10-17",
     "Statement":[
     {
       "Action":[
         "lambda:InvokeFunction"
       ],
       "Effect": "Allow",
       "Resource": "${var.pythonfunctionapparn}"

     }
     ]
   }
   EOF
}

#AWS State function
resource "aws_sfn_state_machine" "sfn_state_machine"{
   name   = "cloudquickpocsstepfunction"
   role_arn = aws_iam_role.step_function_role.arn

   definition = <<EOF
   {
      "Comment": "Invoke aws Lambda from aws Step Function with Terrafrom",
       "StartAt": "ExampleLambdaFunctionApp",
       "States":{
          "ExampleLambdaFunctionApp":{
             "Type": "Task",
             "Resource": "${var.pythonfunctionapparn}"
             "End": true
          }
       }

   }
    EOF
}