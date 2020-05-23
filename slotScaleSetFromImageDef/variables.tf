variable "subscription_id" {
  default = "8738fb6b-de4b-4fd8-8023-e17f7ef42b29"
}

variable "resource_group_name" {
  default = "shrfRG"
}

variable "network_subnet_id" {
  #default = "/subscriptions/8738fb6b-de4b-4fd8-8023-e17f7ef42b29/resourceGroups/mc-api-gateway/providers/Microsoft.Network/virtualNetworks/mc-api-gateway-apigateway-vnet/subnets/NetworkSubnet"
  default = "/subscriptions/8738fb6b-de4b-4fd8-8023-e17f7ef42b29/resourceGroups/shrfRG/providers/Microsoft.Network/virtualNetworks/shrfRG-gateway-vnet/subnets/GatewaySubnet2"
}

variable "network_security_group_id" {
  #default = "/subscriptions/8738fb6b-de4b-4fd8-8023-e17f7ef42b29/resourcegroups/mc-api-gateway/providers/Microsoft.Network/networkSecurityGroups/TSE-Slotworker"
  default = "/subscriptions/8738fb6b-de4b-4fd8-8023-e17f7ef42b29/resourceGroups/shrfRG/providers/Microsoft.Network/networkSecurityGroups/TSE-227-6ee-NSG"
}

variable "image_id" {
  #default = "/subscriptions/8738fb6b-de4b-4fd8-8023-e17f7ef42b29/resourceGroups/mc-api-gateway/providers/Microsoft.Compute/images/TSESlotVMBaseImage"
  default = "/subscriptions/8738fb6b-de4b-4fd8-8023-e17f7ef42b29/resourceGroups/shrfRG/providers/Microsoft.Compute/images/SlotVMBaseImageWest2"
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
  default = "HelloWorld12"
}

variable "db_username" {
  default = "adminuser"
 }

 variable "db_password" {
  type = string
  default = "HelloWorld123456"
}

variable "slotworkerdb_server" {
  default = "shared-tse.10493540c67a.database.windows.net"
}

variable "systemdb_server" {
  default = "shared-tse.10493540c67a.database.windows.net"
}

variable "slotworker_cluster_name" {
  default = "TSE Service Cluster"
}

variable "self_register_script_url" {
  #default = "https://mcapigatewaydsk.blob.core.windows.net/slot/SelfRegisterMachine-Template.ps1"
  default = "https://mcapigateway.blob.core.windows.net/slot/SelfRegisterMachine-Template.ps1"
}
# variable "sas_token" {
#   type = string
# }

variable "self_register_script_name" {
  default = ".\\SelfRegisterMachine-Template.ps1"
}