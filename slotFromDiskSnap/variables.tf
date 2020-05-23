variable "subscription_id" {
  default = ""
}

variable "resource_group_name" {
  default = "myResourcegroup"
}

variable "network_subnet_id" {
  default = "/subscriptions/{subscription_id}/resourceGroups/myResourceGroup/providers/Microsoft.Network/virtualNetworks/myResourceGroup-gateway-vnet/subnets/GWSN"
}

variable "disk_snap_id" {
  default = "/subscriptions/{subscription_id}/resourceGroups/myResourceGroup/providers/Microsoft.Compute/snapshots/mySlotSnapshot"
}
