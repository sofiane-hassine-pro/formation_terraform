variable "location" {
  type    = string
  default = "westeurope"
  validation {
    condition     = contains(["francecentral", "westeurope", "northeurope", "eastus"], var.location)
    error_message = "Location must be one of: francecentral, westeurope, northeurope, eastus."
  }
}

variable "env" {
  type        = string
  description = "Environnement cible"
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.env)
    error_message = "env doit être dev, staging ou prod."
  }
}

variable "tags_incomplete" {
  type        = map(string)
  description = "Tags additionnels fusionnés avec les tags communs"
  default = {
    project = "lab-terraform"
    owner   = "owner_name"
  }
}

variable "enable_public_ip" {
  type        = bool
  description = "Enable public IP on VM"
  default     = false
}
variable "vm_config" {
  type = object({
    name    = string
    size    = string
    os_disk = number
  })
  default = {
    name    = "vm-lab4"
    size    = "Standard_B1s"
    os_disk = 128
  }
}

variable "vm_sku" {
  type        = string
  description = "Azure VM size / SKU"
  default     = "Standard_F1als_v7"

  validation {
    condition     = length(var.vm_sku) > 4 && substr(var.vm_sku, 0, 8) == "Standard"
    error_message = "VM SKU must be a valid Azure size starting with \"Standard\"."
  }
}
