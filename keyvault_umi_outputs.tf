# key vault resource id
output "key_vault_resource_id" {
  value = module.keyvault.resource_id
}

# user managed identity principal id
output "user_managed_identity_principal_id" {
  value = module.umi.principal_id
}

# user managed identity client id
output "user_managed_identity_client_id" {
  value = module.umi.client_id
}

# user managed identity resource id
output "user_managed_identity_resource_id" {
  value = module.umi.resource_id
}