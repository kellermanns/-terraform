//variable "cda_server" {default = "http://10.55.19.254/cda"}
variable "cda_server" {default = "http://STOZH01L7480/cda"}
//variable "cda_server" {default = "http://STOZH01L7480:80/cda"}
variable "cda_user" {default = "100/AUTOMIC/AUTOMIC"}
variable "cda_password" {default = ""}

locals {
	id = "${random_integer.name_extension.result}"
}

resource "random_integer" "name_extension" {
  min     = 1
  max     = 99999
}

provider "cda" {
  cda_server     = "${var.cda_server}"
  user           = "${var.cda_user}"
  password       = "${var.cda_password}"  
}
 
resource "cda_environment" "firstEnvironment" {
  name               = "jeny-${local.id}"
  folder             = "DEFAULT"
  type               = "Generic"
  description        = "Description Update"
  owner              = "100/AUTOMIC/AUTOMIC"
  
  dynamic_properties = {
      "name1" = "value1"
      "name2" = "value2"
  }
  
  custom_properties = {}
  
  deployment_targets = ["Local SQLLite DB", "Local Tomcat"]
}

resource "cda_deployment_target" "jenys_target" {
  name        = "jeny-${local.id}"
  type        = "Database JDBC"
  folder      = "DEFAULT"
  owner       = "100/AUTOMIC/AUTOMIC"
  //agent       = "WIN01"
}

resource "cda_login_object" "my_login_object" {
  name        = "test_login_object"
  folder      = "DEFAULT"
  owner       = "100/AUTOMIC/AUTOMIC"

  credentials = [
    {
      agent      = "*"
      type       = "WINDOWS"
      username   = "Agent_User"
      password   = "automic"
    }
  ]
}

resource "cda_deployment_profile" "my_deployment_profile" {
  name         = "test_profile"
  folder       = "DEFAULT"
  owner        = "100/AUTOMIC/AUTOMIC"
  application  = "application"
  environment  = "${cda_environment.firstEnvironment.name}"
  login_object = "cda_login_object.my_login_object.name"

/*
  deployment_map = [
    {
      component = "component_2"
      targets = ["target_name1", ..., "target_nameN"]
    },
    {
      component = "component_2"
      targets = ["target_name1", ..., "target_nameN"]
    }
  ]
*/
// deployment_map = {
//    component1 = "target_name1, ..., target_nameN"
//    component2 = "target_name11, ..., target_nameN1"
//    component3 = "target_name111, ..., target_nameN11"
//  }
}
