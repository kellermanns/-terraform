variable "aws_access_key" {}
variable "aws_secret_key" {}
//variable "aws_ami" {default = "ami-0080e4c5bc078760e"}
variable "aws_ami" {default = "ami-04b9e92b5572fa0d1"}
variable "aws_security_group_id" {default = "sg-495c840a"}
variable "instance_type" {default = "t2.micro"}

provider "aws" {
  region     = "us-east-2"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

resource "aws_instance" "automic_default" {
  ami                    = "${var.aws_ami}"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${var.aws_security_group_id}"]
  key_name	             = "AWS Default"
}

provisioner "automic_agent_install" {
    destination = ""${var.installation_dir}"" //The target directory on the instance, where the installation script and the Agent and Service Manager binaries will be copied.
    source = "C:\\Automic\\Terraform\\tf_linux_amd64\\linux_amd64" //The folder where the installation script, the Agent and Service Manager binaries are downloaded.

    agent_name = "${random_string.cda_entity_name.result}"
    agent_port = "${var.agent_port}"
    ae_system_name = "${var.ae_system_name}"
    ae_host = "${var.ae_host}"
    ae_port = "${var.ae_port}"
    sm_port = "${var.sm_port}"
    sm_name = "${var.sm_name}"

    variables = {
      UC_EX_PATH_JOBREPORT = "../tmp"   //overrides existing variable
      UC_EX_PATH_TEMP = "../tmp"    //overrides existing variable
      UC_EX_NEW_VARIABLE = "VALUE"    //adds new variable to agent configuration
      UC_EX_IP_ADDR = "${self.public_ip}"   //adds new variable to the agent configuration
    }
