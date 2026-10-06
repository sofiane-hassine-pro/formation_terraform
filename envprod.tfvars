variable "env" {
  type        = string
  description = "Environnement cible"
  default     = "prod"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.env)
    error_message = "env doit être dev, staging ou prod."
  }
}