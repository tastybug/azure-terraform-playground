# resource "random_password" "pass" {
#   length = 20
# }

# resource "azurerm_postgresql_flexible_server" "default" {
#   name                   = "${random_pet.name_prefix.id}-server"
#   resource_group_name    = azurerm_resource_group.default.name
#   location               = azurerm_resource_group.default.location
#   version                = "16"
#   administrator_login    = "pgadmin"
#   administrator_password = random_password.pass.result
#   zone                   = "1"
#   storage_mb             = 32768
#   sku_name               = "B_Standard_B1ms"  # Small Burstable tier
#   public_network_access_enabled = true  # Enable public access
# }

# resource "azurerm_postgresql_flexible_server_database" "default" {
#   name      = "${random_pet.name_prefix.id}-db"
#   server_id = azurerm_postgresql_flexible_server.default.id
#   collation = "en_US.utf8"
#   charset   = "UTF8"
# }

# output "server_fqdn" {
#   value = azurerm_postgresql_flexible_server.default.fqdn
# }

# output "admin_password" {
#   value     = random_password.pass.result
#   sensitive = true
# }