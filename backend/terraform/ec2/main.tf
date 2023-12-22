terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "5.9.0"
    }
  }
}

provider "aws" {
    access_key = var.access_key
    secret_key = var.secret_key
    region = var.region
}

resource "aws_instance" "this" {
    ami = "ami-093cb9fb2d34920ad"
    instance_type = "t2.micro"
}