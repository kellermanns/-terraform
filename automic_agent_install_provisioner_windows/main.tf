variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_ami" {default = "ami-00dd3069"}
variable "aws_security_group_id" {default = "sg-495c840a"}
variable "instance_type" {default = "t2.micro"}
variable "cda_server" {default = "http://STOZH01L7480/cda"}
variable "cda_user" {default = "100/AUTOMIC/AUTOMIC"}
variable "cda_password" {}
variable "remote_working_dir" {default = "/home/ubuntu/AE"}
variable "private_key_file" {default = "C:\\Terraform\\EM\\AWS_Key\\jeny-key-us-east-1.pem"}
variable "package" {default = "no-package"}

provider "aws" {
  region     = "us-east-1"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

resource "aws_instance" "cda_instance" {
  ami                    = "${var.aws_ami}"
  instance_type          = "t2.large"
  vpc_security_group_ids = ["${var.aws_security_group_id}"]
  key_name	         = "jeny-key-us-east-1"

  tags = {
    Name = "agent_provisioner_instance"
  }
  
  user_data     = <<EOF
  <powershell>
    net user ${var.agent_user} '${var.agent_pass}'
    winrm quickconfig -q
    winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="300"}'
    winrm set winrm/config '@{MaxTimeoutms="1800000"}'
    winrm set winrm/config/service '@{AllowUnencrypted="true"}'
    winrm set winrm/config/service/auth '@{Basic="true"}'
    netsh advfirewall firewall add rule name="WinRM 5985" protocol=TCP dir=in localport=5985 action=allow
    netsh advfirewall firewall add rule name="WinRM 5986" protocol=TCP dir=in localport=5986 action=allow
    net stop winrm
    sc.exe config winrm start=auto
    net start winrm
  </powershell>
  EOF
 
  provisioner "automic_agent_install" {
    source = "C:/Users/tp674035/Documents/Projects/go-workspace/src/terraform-provisioner-cda/artifacts/windows/install"
    destination = "${var.remote_working_dir}"

    agent_name = "${random_string.cda_entity_name.result}"
    agent_port = "${var.agent_port}"
    ae_system_name = "${var.ae_system_name}"
    ae_host = "${var.ae_host}"
    ae_port = "${var.ae_port}"
    sm_port = "${var.sm_port}"
    sm_name = "${var.sm_name}${random_string.cda_entity_name.result}"

    variables = {
      UC_EX_PATH_JOBREPORT = "../tmp"
      UC_EX_PATH_TEMP = "../tmp"
      UC_EX_IP_ADDR = "${self.public_ip}"
    }


    connection {
      host = self.public_ip
      type        = "winrm"
      user        = "${var.agent_user}"
      password = "${var.agent_pass}"
    }
  }  
}

resource "random_string" "cda_entity_name" {
  length  = 10
  special = false
  lower   = false
}

output "public_ip" {
  value = "${aws_instance.cda_instance.public_ip}"
}

output "agent_name" {
  value = "${var.agent_name_prefix}${random_string.cda_entity_name.result}"
}

