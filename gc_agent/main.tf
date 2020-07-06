variable "project" {default = "esd-general-dev"}
variable "region" {default = "us-west1"}
variable "subnetwork" {default = "test-network-sub"}
variable "image" {default = "ubuntu-1604-xenial-v20190212"}
variable "gc_credentials" {}
variable "infrastructure_name" {default = "big-sales-data"}
variable "zone" {default = "us-west1-b"}


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
  project      = "${var.project}"
  zone         = "${var.zone}"
  name         = "${var.infrastructure_name}-${local.id}"
  machine_type = "f1-micro"
  
  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }
  
  network_interface {
    subnetwork = "${var.subnetwork}"
    subnetwork_project = "${var.project}"
	  	  access_config {
      // Ephemeral IP - leaving this block empty will generate a new external IP and assign it to the machine
    }
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
      			UC_EX_IP_ADDR = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
    		}

    		connection {
      			host = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
      			type = "ssh"
      			user = "ubuntu"
      			private_key = "${file("${var.private_key_file}")}"
    		}
  	} 
}

resource "random_string" "append_string" {
	length  = 10
	special = false
	lower   = false
}
