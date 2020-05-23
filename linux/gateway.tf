#====================================
# VPN Gateway
#====================================

# provider config
provider "azurerm" {
  alias           = "POC"
  subscription_id = var.subscription_id
  version         = "2.0.0"
  features {}
}

# create resource groups
data "azurerm_resource_group" "resourcegroup" {
  provider = azurerm.POC
  name     = "${var.resource_group_name}"
}

# create gateway vnet
resource "azurerm_virtual_network" "gateway" {
  provider            = azurerm.POC
  name                = "${var.resource_group_name}-gateway-vnet"
  resource_group_name = var.resource_group_name
  address_space       = [var.gateway_network]
  location            = data.azurerm_resource_group.resourcegroup.location
}

# create gateway 2 subnet
resource "azurerm_subnet" "gateway" {
    provider             = azurerm.POC
    name                 = "GatewaySubnet"
    virtual_network_name = azurerm_virtual_network.gateway.name
    resource_group_name  = var.resource_group_name
    address_prefix       = var.gateway_subnet
}

resource "azurerm_subnet" "gateway2" {
    provider             = azurerm.POC
    name                 = "GatewaySubnet2"
    virtual_network_name = azurerm_virtual_network.gateway.name
    resource_group_name  = var.resource_group_name
    address_prefix       = var.gateway_subnet2
}

# create gateway 2 public IP
resource "azurerm_public_ip" "gateway" {
  provider            = azurerm.POC
  name                = "${var.resource_group_name}-gateway-pip"
  location            = data.azurerm_resource_group.resourcegroup.location
  resource_group_name = var.resource_group_name

  allocation_method = "Dynamic"
}

# create vpn config
resource "azurerm_virtual_network_gateway" "gateway" {
  provider            = azurerm.POC
  name                = "${var.resource_group_name}-vpngw"
  location            = data.azurerm_resource_group.resourcegroup.location
  resource_group_name = var.resource_group_name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "${var.resource_group_name}-gateway-vpngwip"
    public_ip_address_id          = azurerm_public_ip.gateway.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway.id
  }

  vpn_client_configuration {
    address_space = [var.gateway_client_subnet]

    root_certificate {
        name             = "${var.root_cert_name}"
        public_cert_data = "${var.root_cert_pub_key}"    
    }
 }
}

# create security group to connect
resource "azurerm_network_security_group" "myterraformnsg" {
	provider            = azurerm.POC
    name                = "myNetworkSecurityGroup"
    location            = data.azurerm_resource_group.resourcegroup.location
    resource_group_name = var.resource_group_name 
    
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

# create network interface
resource "azurerm_network_interface" "myterraformnic" {
	provider            		= azurerm.POC
    name                        = "myNIC"
    location                    = data.azurerm_resource_group.resourcegroup.location
    resource_group_name         = var.resource_group_name 

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = azurerm_subnet.gateway2.id 
        private_ip_address_allocation = "Dynamic"
    }
}

# Link security group to network interface
resource "azurerm_network_interface_security_group_association" "main" {
	provider            		= azurerm.POC
	network_interface_id      	= azurerm_network_interface.myterraformnic.id
	network_security_group_id 	= azurerm_network_security_group.myterraformnsg.id
}

resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = var.resource_group_name
    }
    
    byte_length = 8
}

#create storage account
resource "azurerm_storage_account" "mystorageaccount" {
	provider            		= azurerm.POC
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = var.resource_group_name 
    location                    = data.azurerm_resource_group.resourcegroup.location
    account_replication_type    = "LRS"
    account_tier                = "Standard"
}

# Create the Linux VM
resource "azurerm_virtual_machine" "myterraformvm" {
	provider			  = azurerm.POC
    name                  = "myTerraVM"
    location              = data.azurerm_resource_group.resourcegroup.location
    resource_group_name   = var.resource_group_name
    network_interface_ids = [azurerm_network_interface.myterraformnic.id]
    vm_size               = "Standard_DS1_v2"

    storage_os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04.0-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "myterravm"
        admin_username = "azureuser"
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/azureuser/.ssh/authorized_keys"
            key_data = file("~/.ssh/id_rsa.pub")
        }
    }

    boot_diagnostics {
        enabled     = "true"
        storage_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
    }
}