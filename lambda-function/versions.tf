terraform {
    required_version = "0.14.2"
    required_providers {
        aws = {
        version = ">= 3.50.0"
        source = "hashicorp/aws"
        }
    }
}
