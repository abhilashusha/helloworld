variable "default_tags" {
  default = {

    Terraform   = "true"
    
    Region      = "us-east-1"
    Purpose     = "Api gateway"

  }
  description = "Default Tags"
  type        = map(string)
}