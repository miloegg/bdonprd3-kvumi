
## resource group
resource "azurerm_resource_group" "this" {
  location = "southeastasia"
  name     = "kvumi-rg"
}

## user assigned managed identity
module "umi" {
  source              = "Azure/avm-res-managedidentity-userassignedidentity/azurerm"
  version             = "0.3.4"
  location            = azurerm_resource_group.this.location
  name                = "demoumi"
  resource_group_name = azurerm_resource_group.this.name
  enable_telemetry    = false
}

# only access policies supported as per https://learn.microsoft.com/en-us/azure/firewall/premium-certificates
# allow public access initially to allow import of certificate first, then disable later
module "keyvault" {
  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "0.10.2"

  location            = azurerm_resource_group.this.location
  name                = "demobdokv1234"
  resource_group_name = azurerm_resource_group.this.name
  tenant_id           = "00000000-0000-0000-0000-000000000000"
  enable_telemetry    = false
  legacy_access_policies = {
    test = {
      object_id               = module.umi.principal_id
      secret_permissions      = ["Get", "List"]
      certificate_permissions = ["Get", "List"]
    }
  }
  network_acls = {
    bypass = "AzureServices"
  }
  public_network_access_enabled  = true
  legacy_access_policies_enabled = true
}