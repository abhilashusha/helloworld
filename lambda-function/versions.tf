terraform {
    required_version = "1.0.11"
    required_providers {
        aws = {
        version = ">= 3.50.0"
        source = "hashicorp/aws"
        }
    }
}
