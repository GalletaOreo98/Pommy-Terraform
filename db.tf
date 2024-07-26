resource "azurerm_mssql_server" "pommy_sql_server" {
    name = "sqlserver-${var.project}-${var.environment}"
    resource_group_name = azurerm_resource_group.pommy_rg.name
    location = var.location
    version = "12.0"
    administrator_login = "sqladmin"
    administrator_login_password = var.password

    tags = var.tags

}

resource "azurerm_mssql_database" "pommy_sql_db"{
    name = "pommy.db"
    server_id = azurerm_mssql_server.pommy_sql_server.id
    sku_name = "S0"

    tags = var.tags
}

resource "azurerm_private_endpoint" "pommy_sql_private_endpoint" {
    name = "sql-private-endpoint-${var.project}-${var.environment}"
    resource_group_name = azurerm_resource_group.pommy_rg.name
    location = var.location
    subnet_id = azurerm_subnet.subnetdb.id

    private_service_connection {
        name = "sql-server-ec-${var.project}-${var.environment}"
        private_connection_resource_id = azurerm_mssql_server.pommy_sql_server.id
        subresource_names = ["sqlServer"]
        is_manual_connection = false
    }

    tags = var.tags
}

resource "azurerm_private_dns_zone" "pommy_private_dns_zone"{
    name = "private.dbserver.database.windows.net"
    resource_group_name = azurerm_resource_group.pommy_rg.name

    tags = var.tags    
}

resource "azurerm_private_dns_a_record" "pommy_private_dns_a_record" {
    name = "sqlserver-record-${var.project}-${var.environment}"
    zone_name = azurerm_private_dns_zone.pommy_private_dns_zone.name
    resource_group_name = azurerm_resource_group.pommy_rg.name
    ttl = 300
    records = [azurerm_private_endpoint.pommy_sql_private_endpoint.private_service_connection[0].private_ip_address]
}

resource "azurerm_private_dns_zone_virtual_network_link" "pommy_vnet_link" {
    name = "vnetlink-${var.project}-${var.environment}"
    resource_group_name = azurerm_resource_group.pommy_rg.name
    private_dns_zone_name = azurerm_private_dns_zone.pommy_private_dns_zone.name
    virtual_network_id = azurerm_virtual_network.pommy_vnet.id
}

resource "azurerm_sql_firewall_rule" "allow_my_ip" {
  name = "allow-my-ip"
  resource_group_name = azurerm_mssql_server.pommy_sql_server.resource_group_name
  server_name = azurerm_mssql_server.pommy_sql_server.name
  start_ip_address = "179.49.112.0"
  end_ip_address = "179.49.112.255"
}