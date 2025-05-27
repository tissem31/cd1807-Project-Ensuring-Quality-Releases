terraform {
  backend "azurerm" {
    storage_account_name = "tfstate469626245"
    container_name       = "tfstate"
    key                  = "projectEnsuringQualityReleases.tfstate"
    access_key           = "c49wchTTCsDJCupktm9dN5XnBpVVxl8yhM41mTWzN1uL+l+UmPPWws1AOAvxeIWLB3xUfqzH/bQK+ASt/GbR1A=="
  }
}
