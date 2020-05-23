variable "subscription_id" {
  default = "6f35427a-d288-49bf-a330-83f34d5cdd3e"
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
  default = "MIICrDCCAZQCCQCerwE1dZ+tRDANBgkqhkiG9w0BAQsFADAYMRYwFAYDVQQDDA1WUE4gU0hBUkVEIENBMB4XDTIwMDIyODE1MTUwN1oXDTIzMDIyNzE1MTUwN1owGDEWMBQGA1UEAwwNVlBOIFNIQVJFRCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANk9c5hP2p4xJhP4P1Vw7mBLcuHCvmIZg/hSHMURYE8BroWUdegIZywhMl2oXSgHPwIrfg93RxUwt/M7JOFL768BtVKbrGhf4kw210jYXkNC2bYbsdEZ55ANf/X2e2wdvM+D+7G5+ybUcIuIVLi7oS+JhLJprJgnm9sWe4CxQLWE99iexbX6SmkSHjIccrqYeRWUbN/LRujFKg98lu9+HBNC8QI7jSvU0VBFc1lnHQqpHkrZtYGhUQVzXTjoiCno7lMZcuV5jLIxtbYFd4gKFWFAuU/9/Nz2QpBwFJowPAeZ3J5fnIB67eWOKLLL+qE8bkIsbyAcrIpgxCpB1gVwB/UCAwEAATANBgkqhkiG9w0BAQsFAAOCAQEAPMytwja0xkQCl/X4/pvJSGYglt6UgVOZTmyqReJ+p8nr9z2ylmAtTn9Ue5sR5X4L06+q27XmISv4DiUuCqkduvavfMmsWC659Jk1Pf3E0UtNXbEw5xXRSwDziRR79XGjvn6Hg8WK9XrcOCxWlaBubHssdYpmnIm6ARrQ8wsGQ85M7Jd5i1YG0aK/DU9tWsL7B+tiWhGm9r/R2Z1+tFBcKZJ7/zEkBgiMk9C5pBhtS2cHVrJmy1KQfm9PI/j9F4TAT2eEvAOQ7aCI3blddbN6SSTPDuhZFE4FjhfCKKgtscCgkwON62Chxuy4Ry944Jrn6Ld7k3aZCDQhpwto57Vkmg=="
}