# provider config
provider "azurerm" {
  alias           = "POC"
  subscription_id = var.subscription_id
  version         = "2.0.0"
  features {}
}

# use resource groups
data "azurerm_resource_group" "resourcegroup" {
  provider = azurerm.POC
  name     = var.resource_group_name
}

resource "azurerm_lb" "vmss" {
 name                = "${var.prefix_for_scaleset_resources}${var.scaleset_version}-LB"
 provider            = azurerm.POC
 location            = data.azurerm_resource_group.resourcegroup.location
 resource_group_name = var.resource_group_name
 sku                 = "Standard"
 frontend_ip_configuration {
   name                 = "${var.prefix_for_scaleset_resources}${var.scaleset_version}-FEIPA"
   subnet_id            = var.network_subnet_id
 }
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
 provider             = azurerm.POC
 resource_group_name = var.resource_group_name
 loadbalancer_id     = azurerm_lb.vmss.id
 name                = "${var.prefix_for_scaleset_resources}${var.scaleset_version}-BEAP"
}

resource "azurerm_lb_probe" "vmss" {
 provider             = azurerm.POC
 resource_group_name = var.resource_group_name
 loadbalancer_id     = azurerm_lb.vmss.id
 name                = "${var.prefix_for_scaleset_resources}${var.scaleset_version}-HP"
 protocol            = "TCP"
 port                = var.health_check_port
}

resource "azurerm_lb_rule" "lbnatrule" {
   provider                       = azurerm.POC
   resource_group_name            = var.resource_group_name
   loadbalancer_id                = azurerm_lb.vmss.id
   name                           = "${var.prefix_for_scaleset_resources}${var.scaleset_version}-lbr"
   protocol                       = "Tcp"
   frontend_port                  = var.health_check_port
   backend_port                   = var.health_check_port
   backend_address_pool_id        = azurerm_lb_backend_address_pool.bpepool.id
   frontend_ip_configuration_name = "${var.prefix_for_scaleset_resources}${var.scaleset_version}-FEIPA"
   probe_id                       = azurerm_lb_probe.vmss.id
}

# Create the windows VM Scale set
resource "azurerm_windows_virtual_machine_scale_set" "main" {
  provider             = azurerm.POC
  name                 = "${var.prefix_for_scaleset_resources}${var.scaleset_version}-vmss"
  resource_group_name  = var.resource_group_name
  location             = data.azurerm_resource_group.resourcegroup.location
  sku                  = "Standard_D4_v3"
  instances            = var.no_of_scaleset_instances
  admin_username       = var.admin_username
  admin_password       = var.admin_password
  computer_name_prefix = "${var.prefix_for_scaleset_resources}${var.scaleset_version}"
  source_image_id      = var.image_id
  upgrade_mode         = "Rolling"

  rolling_upgrade_policy {
    max_batch_instance_percent              = 20
    max_unhealthy_instance_percent          = 20
    max_unhealthy_upgraded_instance_percent = 5
    pause_time_between_batches              = "PT0S"
  }

  health_probe_id = azurerm_lb_probe.vmss.id

  network_interface {
    name                      = "${var.prefix_for_scaleset_resources}${var.scaleset_version}-nic"
    primary                   = true
    network_security_group_id = var.network_security_group_id
    ip_configuration {
      name      = "${var.prefix_for_scaleset_resources}${var.scaleset_version}-subnet"
      primary   = true
      subnet_id = var.network_subnet_id
      load_balancer_backend_address_pool_ids=[azurerm_lb_backend_address_pool.bpepool.id]
    }
  }
  
  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}
resource "azurerm_virtual_machine_scale_set_extension" "self-register-slot" {
  provider                     = azurerm.POC
  name                         = "self-register-slot"
  virtual_machine_scale_set_id = azurerm_windows_virtual_machine_scale_set.main.id
  publisher                    = "Microsoft.Compute"
  type                         = "CustomScriptExtension"
  type_handler_version         = "1.9"
  settings = jsonencode({
    #"fileUris" : ["${var.self_register_script_url}?${var.sas_token}"],
    "fileUris" : ["${var.self_register_script_url}"],
    "commandToExecute" : "powershell.exe -ExecutionPolicy Unrestricted -Command ${var.self_register_script_name} -systemdbservername \"${var.systemdb_server}\" -slotworkerservername \"${var.slotworkerdb_server}\" -dbusername \"${var.db_username}\"  -dbpassword \"${var.db_password}\" -clustername \"${var.slotworker_cluster_name}\""
  })
} 
