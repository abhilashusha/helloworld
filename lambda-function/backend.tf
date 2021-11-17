terraform {

 backend "s3" {
    bucket         = "quizwizard-tfstate"
    region         = "us-east-1"
    encrypt        = "true"
    dynamodb_table = "TF_LOCK_TABLE"
    key            = "quizwizard-helloworld.tfstate"
  }

}