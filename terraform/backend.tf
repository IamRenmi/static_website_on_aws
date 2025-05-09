terraform {
  backend "s3" {
    bucket         = "my-tfstate-bucket"
    key            = "wordpress/dev.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "tfstate-lock"
  }
}