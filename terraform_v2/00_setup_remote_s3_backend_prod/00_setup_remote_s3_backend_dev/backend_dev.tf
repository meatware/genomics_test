terraform {
  required_version = ">= 0.12.2"

  backend "s3" {
    region         = "eu-west-1"
    bucket         = "tf-backend-dev-genomics-6666"
    key            = "terraform.tfstate"
    dynamodb_table = "tf-backend-dev-genomics-6666"
    profile        = ""
    role_arn       = ""
    encrypt        = "true"
  }
}
