# Resource Group
variable resource_group {
    description = "the name of the resource group in which to create the subnet. This must be the resource group that the virtual network resides in"
    type = string
}
variable location {
    description = "The Azure Region where the Resource Group should exist."
    type = string
}
# Network
variable virtual_network_name {
    description = "The name of the virtual network to which to attach the subnet. Changing this forces a new resource to be created"
    type = string
}
variable address_space {
    description = "The address space that is used the virtual network. You can supply more than one address space."
    type = string
}
variable "application_type" {
    type = string
}
variable "resource_type" {
    type = string
}
variable "address_prefix_test" {
    description = "The address prefixes to use for the subnet."
    type = string
}

