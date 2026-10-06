#ne modifie pas l'objet tags, produit une valeur dans le local uniquement 
# locals {
#   tags = merge(var.tags_incomplete, { env = var.env })
#   Name        = var.env == "prod" ? "production" : "developpement"

# }

locals {
  tags = {
    Name        = var.env == "prod" ? "production" : "developpement"
    Project     = "GOP"
    Team        = "Devops"
    Environment = var.env
  }

  vm_name     = "vm-${var.env}-lab"
  rg_name     = "rg-${var.env}-lab"
}