variable "env" {
  type        = string
  description = "Environnement cible"
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.env)
    error_message = "env doit être dev, staging ou prod."
  }
}