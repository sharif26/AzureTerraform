variable "subscription_id" {
  default = ""
}

variable "resource_group_name" {
  default = "myResourceGroup"
}

variable "gateway_network" {
  default = "8.8.8.0/24"
}

variable "gateway_subnet" {
  default = "8.8.8.0/25"
}

# subnet for VM with 10 available IPv4 addresses 
variable "gateway_subnet2" {
  default = "8.8.8.144/28"
}

variable "gateway_client_subnet" {
  default = "192.168.130.0/24"
}

variable "root_cert_name" {
  default = "VPN_SHARED_CA"
}

variable "root_cert_pub_key" {
  default = ""
}
