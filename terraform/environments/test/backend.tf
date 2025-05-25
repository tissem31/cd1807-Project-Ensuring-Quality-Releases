terraform {
  backend "azurerm" {
    storage_account_name = "tfstate20128356"
    container_name       = "tfstate"
    key                  = "projectEnsuringQualityReleases.tfstate"
    access_key           = "pPmx+OYk2P4tx8VDcYsX94DO23QHV3DiOVIDtSpTbtdI2pJkpmt/wFCCSBr0FmB306QHxtOo+lLW+AStL0Y0BQ=="
  }
}
