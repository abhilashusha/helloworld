variable "aws_region" {
    type = string
    default = "us-east-1"
}

variable "aws_account" {
   
}

# variable allowed_cidr {
#     default = ["207.141.125.0/24","63.170.46.0/24","65.172.252.0/22","65.171.4.0/22","205.242.82.0/23","207.140.132.0/23","207.140.134.0/24","208.11.196.0/22"]
#     description = "allowed cidr range for api access"
# }

variable "log_group_name" {
   
}

variable lambda_functions {
  
}

variable env_props {

}
