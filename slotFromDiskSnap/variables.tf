variable "subscription_id" {
  default = "6f35427a-d288-49bf-a330-83f34d5cdd3e"
}

variable "resource_group_name" {
  default = "myResourcegroup"
}

variable "network_subnet_id" {
  default = "/subscriptions/6f35427a-d288-49bf-a330-83f34d5cdd3e/resourceGroups/myResourceGroup/providers/Microsoft.Network/virtualNetworks/myResourceGroup-gateway-vnet/subnets/GWSN"
}

variable "disk_snap_id" {
  default = "/subscriptions/6f35427a-d288-49bf-a330-83f34d5cdd3e/resourceGroups/myResourceGroup/providers/Microsoft.Compute/snapshots/mySlotSnapshot"
}
