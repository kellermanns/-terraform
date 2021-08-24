variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_tags" {default = "medium-sales-data"}
variable "aws_ami" {default = "ami-00399ec92321828f5"}
variable "aws_security_group_id" {default = "sg-d28317bb"}
variable "instance_type" {default = "t2.micro"}
variable "remote_working_dir" {default = "/home/ubuntu/AE"}
variable "private_key_file" {default = "C:\\Automic\\Terraform\\AWS.pem"}
variable "agent_port" {default = "2300"}
variable "ae_system_name" {default = "AUTOMIC"}
variable "ae_host" {default = "automic.kellermanns.net"}
variable "ae_port" {default = "2217"}
variable "sm_port" {default = "8871"}
variable "sm_name" {default = "sm_"}
