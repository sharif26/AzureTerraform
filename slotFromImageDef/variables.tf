variable "subscription_id" {
  default = ""
}

variable "resource_group_name" {
  default = "myRG"
}

variable "network_subnet_id" {
  default = "/subscriptions/{subscription_id}/resourceGroups/myRG/providers/Microsoft.Network/virtualNetworks/my-gateway-apigateway-vnet/subnets/NetworkSubnet"
}

variable "image_id" {
  default = "/subscriptions/{subscription_id}/resourceGroups/myRG/providers/Microsoft.Compute/images/VMBaseImage"
}

variable "admin_username" {
  default = "adminuser"
 }

variable "admin_password" {
  default = "P@ssw0rd1234!"
}
