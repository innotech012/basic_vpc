variable "region" {
  type = string
  default = "eu-west-1"
}

variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "pvt_subnet_cidr_list" {

    type = list(string)
    default = [ "" ]
  
}

variable "pub_subnet_cidr_list" {
    type = list(string)
    default = [ "" ]
}

