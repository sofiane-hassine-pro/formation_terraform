# Aide-mémoire Terraform

> Dans les exemples, `tf` est un alias de `terraform`.

## Sommaire

1. [Initialisation (`init`)](#1-initialisation-init)
2. [Plan et apply](#2-plan-et-apply)
3. [Variables](#3-variables)
4. [Outputs](#4-outputs)
5. [Gestion du state](#5-gestion-du-state)
6. [Raccourcis VS Code (macOS)](#6-raccourcis-vs-code-macos)

---

## 1. Initialisation (`init`)

| Commande | Quand l'utiliser |
|---|---|
| `terraform init` | Changement de providers, de modules, etc. |
| `terraform init -reconfigure` | Changement de configuration du backend (setup) |
| `terraform init -upgrade` | Nouvelle version d'un provider ou d'un module |
| `terraform init -migrate-state` | Migration du state vers un nouveau backend |

## 2. Plan et apply

```bash
# Générer un plan et le sauvegarder
terraform plan -out=tfplan

# Appliquer sans confirmation interactive
terraform apply -auto-approve

# Appliquer un plan sauvegardé
terraform apply tfplan
```

## 3. Variables

```bash
# Variable en ligne de commande
terraform plan -var="location=westeurope"

# Fichier de variables
terraform plan -var-file="demo.tfvars"

# Variable d'environnement : TF_VAR_<variable_name>
export TF_VAR_location="westeurope"
```

Exemples avec `apply` :

```bash
# Valeurs passées en ligne (variable de type objet)
terraform apply \
  -var="location=westeurope" \
  -var="vm_config={name=\"vm-prod\",size=\"Standard_D2s_v3\",os_disk=256}"

# Ou via un fichier .tfvars
terraform apply -var-file="prod.tfvars"
```

## 4. Outputs

```bash
terraform output vm_id
```

## 5. Gestion du state

### Commandes

| Commande | Description |
|---|---|
| `terraform state list` | Liste l'ensemble des ressources actuellement suivies dans le fichier de state. |
| `terraform state show <resource>` | Affiche le détail des attributs d'une ressource enregistrée dans le state. |
| `terraform state mv <source> <destination>` | Renomme ou déplace une ressource dans le state, sans la détruire ni la recréer sur l'infrastructure réelle. |
| `terraform state rm <resource>` | Supprime une ressource du state, sans supprimer la ressource réelle sur le cloud. |
| `terraform state pull` | Télécharge et affiche le contenu brut du state depuis le backend distant. |
| `terraform state push` | **DANGEREUX** : envoie un state local qui **écrase** le state du backend distant. |

Exemples :

```bash
terraform state list
terraform state show data.azurerm_resource_group.rg
terraform state mv azurerm_storage_account.sa azurerm_storage_account.sa1
```

### Exemple : renommer une ressource indexée (`for_each`)

Avant :

```text
$ terraform state list
...
azurerm_storage_container.containers["container-1-sof"]
azurerm_storage_container.containers["container-2-sof"]
azurerm_storage_container.containers["container-3-sof"]
```

Commande (sous zsh, mettre les adresses entre **apostrophes**, sinon les crochets et guillemets sont interprétés par le shell) :

```bash
terraform state mv \
  'azurerm_storage_container.containers["container-3-sof"]' \
  'azurerm_storage_container.containers["container-3-sof-renamed"]'
```

Après :

```text
$ terraform state list
...
azurerm_storage_container.containers["container-1-sof"]
azurerm_storage_container.containers["container-2-sof"]
azurerm_storage_container.containers["container-3-sof-renamed"]
```

> Pense à adapter aussi la clé dans le code (`for_each`) pour que le prochain `plan` n'affiche aucun changement.

## 6. Raccourcis VS Code (macOS)

| Action | Raccourci |
|---|---|
| Rechercher | `⌘ + F` |
| Remplacer | `⌘ + ⌥ + F` |
| Formater le document | `⇧ + ⌥ + F` |
| Commenter / décommenter | `⌘ + /` |
