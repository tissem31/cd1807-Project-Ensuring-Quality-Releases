provider "azurerm" {
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  features {}
}

# terraform {
#   backend "azurerm" {
#     storage_account_name = "tfstate2797731198"
#     container_name       = "tfstate"
#     key                  = "projectEnsuringQualityReleases.tfstate"
#     access_key           = "C2HtFMMewOzFhNgaisF7Fo6BTBt/YgqNkj7iyIkSt5zM2rnaYqgNvf+fHEDtIqgyZavsRJbCOJjn+AStOVfC2g=="
#   }
# }

module "resource_group" {
  source         = "../../modules/resource_group"
  resource_group = var.resource_group_name
  #location             = "${var.location}"
}
module "network" {
  source               = "../../modules/network"
  address_space        = var.address_space
  location             = var.location
  virtual_network_name = var.virtual_network_name
  application_type     = var.application_type
  resource_type        = "NET"
  resource_group       = module.resource_group.resource_group_name
  address_prefix_test  = var.address_prefix_test
}

module "nsg-test" {
  source              = "../../modules/networksecuritygroup"
  location            = var.location
  application_type    = var.application_type
  resource_type       = "NSG"
  resource_group      = module.resource_group.resource_group_name
  subnet_id           = module.network.subnet_id_test
  address_prefix_test = var.address_prefix_test
}
module "appservice" {
  source           = "../../modules/appservice"
  location         = var.location
  application_type = var.application_type
  resource_type    = "AppService"
  resource_group   = module.resource_group.resource_group_name
}
module "publicip" {
  source           = "../../modules/publicip"
  location         = var.location
  application_type = var.application_type
  resource_type    = "publicip"
  resource_group   = module.resource_group.resource_group_name
}

#================================
# log analytics workspace
#================================
data "azurerm_log_analytics_workspace" "law" {
  name                = "loganalytics-281296"
  resource_group_name = module.resource_group.resource_group_name
}
# ================================
# Diagnostic Setting for App Service -> Log Analytics
# ================================
resource "azurerm_monitor_diagnostic_setting" "appservice_diag" {
  name                       = "appservice-diag"
  target_resource_id         = module.appservice.app_service_id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.law.id

  enabled_log {
    category = "AppServiceHTTPLogs"

    retention_policy {
      enabled = false
      days    = 0
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = false
      days    = 0
    }
  }
}


# ================================
# Action Group for Alerts
# ================================
resource "azurerm_monitor_action_group" "email_alert_group" {
  name                = "app-alert-group"
  resource_group_name = var.resource_group_name
  short_name          = "AppAlerts"

  email_receiver {
    name          = "send-to-student"
    email_address = var.email_receiver
    use_common_alert_schema = true
  }
}

# ================================
# Metric Alert on HTTP 5xx Errors
# ================================
resource "azurerm_monitor_metric_alert" "appservice_cpu_alert" {
  name                = "FakeRestAPI-Failure-Alert"
  resource_group_name = var.resource_group_name
  scopes              = [module.appservice.app_service_id]
  description         = "Alert on failed requests or high response time"
  frequency           = "PT1M"
  window_size         = "PT5M"
  severity            = 2
  enabled             = true

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "Http5xx"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 1
  }

  action {
    action_group_id = azurerm_monitor_action_group.email_alert_group.id
  }
}


# module "virtual_machine" {
#   source               = "../../modules/vm"
#   nic_name             = var.nic_name
#   location             = var.location
#   resource_group       = module.resource_group.resource_group_name
#   subnet_id            = module.network.subnet_id_test
#   public_ip_address_id = module.publicip.public_ip_address_id
#   vm_name              = var.vm_name
#   admin_username       = "azureuseradmin"
#   username             = "azureuseradmin"
# }
