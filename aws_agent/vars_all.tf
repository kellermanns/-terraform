variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_tags" {default = "small-sales-data"}
variable "aws_ami" {default = "ami-013de1b045799b282"}
variable "aws_security_group_id" {default = "sg-081c9b6792f583702"}
variable "instance_type" {default = "t2.micro"}
variable "remote_working_dir" {default = "/home/ubuntu/AE"}
variable "private_key_file" {default = "C:\\Automic\\Terraform\\AWS.pem"}
variable "agent_port" {default = "2300"}
variable "ae_system_name" {default = "AUTOMIC"}
variable "ae_host" {default = "kellermanns.net"}
variable "ae_port" {default = "2217"}
variable "sm_port" {default = "8871"}
variable "sm_name" {default = "sm_"}
