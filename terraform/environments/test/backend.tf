terraform {
  backend "azurerm" {
    storage_account_name = "tfstate5034440"
    container_name       = "tfstate"
    key                  = "projectEnsuringQualityReleases.tfstate"
    access_key           = "cCy3ixBNuDq9HRTQGzTZ1gTka2hqWAAlhC+VIA4AwE37fap2k0iKm+izpSuFuu76VkvgvJ3t3ze++AStmFMdHA=="
  }
}
