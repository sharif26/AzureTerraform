variable "subscription_id" {
  default = "6f35427a-d288-49bf-a330-83f34d5cdd3e"
}

variable "resource_group_name" {
  default = "maheshgautam-gateway"
}

variable "network_subnet_id" {
  default = "/subscriptions/6f35427a-d288-49bf-a330-83f34d5cdd3e/resourceGroups/maheshgautam-gateway/providers/Microsoft.Network/virtualNetworks/maheshgautam-gateway-apigateway-vnet/subnets/NetworkSubnet"
}

variable "image_id" {
  default = "/subscriptions/6f35427a-d288-49bf-a330-83f34d5cdd3e/resourceGroups/maheshgautam-gateway/providers/Microsoft.Compute/images/TSESlotVMBaseImage-1"
}

variable "admin_username" {
  default = "adminuser"
 }

variable "admin_password" {
  default = "P@ssw0rd1234!"
}