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

resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = var.resource_group_name
    }    
    byte_length = 8
}

# create security group to connect
resource "azurerm_network_security_group" "myterraformnsg" {
	provider            = azurerm.POC
    name                = "NetworkSecurityGroup-${substr(random_id.randomId.hex, 0, 3)}"
    location            = data.azurerm_resource_group.resourcegroup.location
    resource_group_name = var.resource_group_name 
    
    security_rule {
        name                       = "RDP"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

# create network interface
resource "azurerm_network_interface" "myterraformnic" {
	provider            		= azurerm.POC
    name                        = "myNIC-mcapigw-${substr(random_id.randomId.hex, 0, 3)}"
    location                    = data.azurerm_resource_group.resourcegroup.location
    resource_group_name         = var.resource_group_name 

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = var.network_subnet_id 
        private_ip_address_allocation = "Dynamic"
    }
}

# Link security group to network interface
resource "azurerm_network_interface_security_group_association" "main" {
	provider            		= azurerm.POC
	network_interface_id      	= azurerm_network_interface.myterraformnic.id
	network_security_group_id 	= azurerm_network_security_group.myterraformnsg.id
}

# Create the Windows VM
resource "azurerm_windows_virtual_machine" "mywindowsterravm" {
	provider			  = azurerm.POC
    name                  = "win-VM-${substr(random_id.randomId.hex, 0, 3)}"
    location              = data.azurerm_resource_group.resourcegroup.location
    resource_group_name   = var.resource_group_name
    network_interface_ids = [azurerm_network_interface.myterraformnic.id]
    size                            = "Standard_F2"
    admin_username                  = var.admin_username
    admin_password                  = var.admin_password

    os_disk {
        storage_account_type = "Standard_LRS"
        caching              = "ReadWrite"
    }

    source_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2016-Datacenter"
        version   = "latest"
    }
}