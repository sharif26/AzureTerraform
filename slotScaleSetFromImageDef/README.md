# MC TSE slotworker
This script is to crete VM scale set from base slotworer image

terraform init

terraform validate

terraform plan

terraform apply

**Assumptions**

-Resource Group has already been created

-Access to base image

-Access to database

-Network subnet in existing resource group to create vm scale set

## File Changes
Please edit the variables.tf file with the appropriate information

**"subscription_id"**

**"resource_group_name"**

**"network_subnet_id"**

**"image_id"** Image to be used for VM scaleset creation

**"network_security_group_id"**

**"prefix_for_scaleset_resources"**

**"no_of_scaleset_instances"** Number of VM in scalset

**"scaleset_version"**

**"admin_username"**

**"admin_password"** export TF_VAR_admin_password=Admin password for VM 

**"db_username"** Username for Database login

**"db_password"** export TF_VAR_db_password=Password for DB login

**"slotworkerdb_server"** Managed Instance host for Slotworker DB server

**"systemdb_server"** Managed Instance host for Slotworker DB server

**"slotworker_cluster_name"**

**"self_register_script_url"** Link to self registrtion script

**"self_register_script_url"** export TF_VAR_sas_token=SAS token to storage account

**"self_register_script_name"** Name of self registration script
