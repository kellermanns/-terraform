variable "project" {default = "esd-general-dev"}
variable "region" {default = "us-west1"}
variable "subnetwork" {default = "test-network-sub"}
variable "image" {default = "ubuntu-1604-xenial-v20190212"}
variable "gc_credentials" {}
variable "infrastructure_name" {default = "demo-infrastructure"}
variable "jiraIssueId" {default = "no Jira Id"}
variable "zone" {default = "us-west1-b"}

variable "num_nodes" {
  description = "Number of nodes to create"
  default     = 1
}

locals {
	id = "${random_integer.name_extension.result}"
}

resource "random_integer" "name_extension" {
  min     = 1
  max     = 99999
}

provider "google" {
  credentials = "${var.gc_credentials}"
  project     = "${var.project}"
  region      = "${var.region}"
}

resource "google_compute_instance" "default" {
  count        = "${var.num_nodes}"
  project      = "${var.project}"
  zone         = "${var.zone}"
  name         = "${var.infrastructure_name}-${count.index + 1}-${local.id}"
  machine_type = "f1-micro"
  
  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }
  
  network_interface {
    subnetwork = "${var.subnetwork}"
    subnetwork_project = "${var.project}"
  }
  provisioner "automic_agent_install" {
  		destination = "${var.remote_working_dir}"
    		source = "C:\\Automic\\Terraform\\tf_linux_amd64\\linux_amd64\\artifacts"

    		agent_name = "${random_string.append_string.result}"
    		agent_port = "${var.agent_port}"
    		ae_system_name = "${var.ae_system_name}"
    		ae_host = "${var.ae_host}"
    		ae_port = "${var.ae_port}"
    		sm_port = "${var.sm_port}"
    		sm_name = "${var.sm_name}${random_string.append_string.result}"

    		variables = {
      			UC_EX_IP_ADDR = ""${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
    		}

    		connection {
      			host = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
      			type = "ssh"
      			user = "ubuntu"
      			private_key = "${file("${var.private_key_file}")}"
    		}
  	} 
}

output "name_output" {
	description = "Instance name"
	value       = "${google_compute_instance.default.*.name[0]}"
}

output "project_output" {
	description = "Project name"
	value       = "${google_compute_instance.default.*.project[0]}"
}

output "internal_ip_output" {
	description = "Internal IP"
	value       = "${google_compute_instance.default.*.network_interface.0.network_ip}"
}

resource "random_string" "append_string" {
	length  = 10
	special = false
	lower   = false
}
