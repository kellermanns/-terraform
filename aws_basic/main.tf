variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_ami" {default = "ami-04b9e92b5572fa0d1"}
variable "aws_security_group_id" {default = "sg-495c840a"}
variable "instance_type" {default = "t2.micro"}


provider "aws" {
	region     = "us-east-2"
	access_key = var.aws_access_key
        secret_key = var.aws_secret_key
	version = "~> 2.70"
}

resource "aws_instance" "automic_instance" {
  	ami                    = var.aws_ami
  	instance_type          = var.instance_type
	vpc_security_group_ids = [var.aws_security_group_id]
  	key_name	         = "AWS Default"
	
  	tags = {
    		Name = var.aws_tags
  	}
