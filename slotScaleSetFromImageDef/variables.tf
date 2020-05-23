variable "subscription_id" {
  default = ""
}

variable "resource_group_name" {
  default = "shrfRG"
}

variable "network_subnet_id" {
  default = "/subscriptions/{subscription_id}/resourceGroups/shrfRG/providers/Microsoft.Network/virtualNetworks/shrfRG-gateway-vnet/subnets/GatewaySubnet2"
}

variable "network_security_group_id" {
  default = "/subscriptions/{subscription_id}/resourceGroups/shrfRG/providers/Microsoft.Network/networkSecurityGroups/TSE-227-6ee-NSG"
}

variable "image_id" {
  default = "/subscriptions/{subscription_id}/resourceGroups/shrfRG/providers/Microsoft.Compute/images/VMBaseImageWest2"
}

variable "prefix_for_scaleset_resources" {
  default = "TSE"
 }
 variable "scaleset_version" {
  default = "227"
 }

variable "no_of_scaleset_instances" {
  default = 3
 }

variable "health_check_port" {
  default = 3389
 }

variable "admin_username" {
  default = "adminuser"
 }
variable "admin_password" {
  type = string
  default = ""
}

variable "db_username" {
  default = "adminuser"
 }

 variable "db_password" {
  type = string
  default = ""
}

variable "slotworkerdb_server" {
  default = "{sql-mi}.10493540c67a.database.windows.net"
}

variable "systemdb_server" {
  default = "{sql-mi}.10493540c67a.database.windows.net"
}

variable "slotworker_cluster_name" {
  default = "TSE Service Cluster"
}

variable "self_register_script_url" {
  default = "https://{storage_container}.blob.core.windows.net/slot/SelfRegisterMachine-Template.ps1"
}

variable "self_register_script_name" {
  default = ".\\SelfRegisterMachine-Template.ps1"
}
