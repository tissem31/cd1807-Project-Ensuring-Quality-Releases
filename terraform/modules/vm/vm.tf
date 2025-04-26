resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip_address_id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  location            = var.location
  resource_group_name = var.resource_group
  size                = "Standard_DS2_v2"
  admin_username      = var.admin_username
  network_interface_ids = [azurerm_network_interface.nic.id]
  admin_ssh_key {
    username   = var.username
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCzV9CThyOKpXmvE36qiMXlQtVS8beTBlYZ94KhggcVXN0e2ZhCTJJhpsVkgACz83FIYYxOPWhszbRk3nlkBs4lIcucdxVonPpN+i0/dUuuVhShiozmDHdWw1a7g52yzg+0rQh4XkI77H0+X7phD+dv6Ve4gA3xpsU4LmiWW2krtraZDEe0YY9lGA3KXcwu8v+HKvEedaWQNo690q9Ay8l1yegj5I5oIpFTmQ3Z60stHznZs1M+rBm3Q3Ie+8Q/SCtP0Qu84WFcKG1sqpjBiBaqSYsUl0SPhLwc9FLqeBHluHDSwbXvp646wzUY69ioWdXsS133pARk8pr3I/Iz0nbT7bGL4NommW/zwiEDDgOGQZbNVPCMEfuisHiipu/E6wM5svI1x4/rukctLOCpYivd7kTYwkK3n8ygZUq4nYVdNxVnBFv3rz4noewtdmiv1r1FMbBsrsRu6y28M2sxUCYDkdqeE6girpGcDFdizo6ZeTTiOKFUg0Xpq0+MX/EP8nM= isegh@LAPTOP-VMF9UIFM"
  }
  os_disk {
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
