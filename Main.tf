  terraform{
    # Terraform version at the time of writing this post
    required_version = ">= 1.8.5"

    backend "s3"{
        bucket = "cloudquickpocsbackendtf"
        key = "quickcloudpocsbackend.tfstate"
        region = "us-east-1"
    }

  }


#   provider "random" {}

#   provider "aws"{
#       region = "us-east-1"
#   }

  #Create Aws Python lambda function
  module "awslambdafunction"{
    source = "./LambdaFunction"
  }


  #Create aws stepfunction to Inovke aws Lambda function
  module "awsstepfunction"{
   source =  "./StepFunction"
   pythonfunctionapparn = module.awslambdafunction.pythonlambdaArn
  }