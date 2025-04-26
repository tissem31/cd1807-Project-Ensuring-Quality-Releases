# Resource Group
# variable location {
#     description = "The Azure Region where the Resource Group should exist."
#     type = string
# }
variable "resource_group" {
    description = "the name of the resource group in which to create the subnet. This must be the resource group that the virtual network resides in"
    type = string
}
