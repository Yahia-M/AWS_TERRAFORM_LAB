# Infrastructure Terraform - Lab AWS

Ce dossier contient toute l'infrastructure Terraform pour le laboratoire AWS.

## 📁 Structure des fichiers

### 🏗️ **Fichiers principaux**
- `backend.tf` - Configuration du backend S3 pour l'état Terraform
- `provider.tf` - Configuration du provider AWS avec credentials
- `versions.tf` - Versions requises de Terraform et des providers
- `variables.tf` - Variables globales du projet

### 🎯 **Ressources AWS**
- `ec2.tf` - Instance EC2 (machine virtuelle)
- `s3.tf` - Bucket S3 (stockage d'objets)
- `outputs.tf` - Valeurs de sortie après déploiement

### 📊 **Variables d'environnement**
- `vars/dev.tfvars` - Variables pour l'environnement de développement
- `vars/staging.tfvars` - Variables pour l'environnement de staging

### 🏢 **Modules**
- `modules/vpc/` - Module pour créer un VPC avec sous-réseaux

## 🚀 Commandes de déploiement

### Initialisation
```bash
# Initialiser Terraform (première fois)
terraform init
```

### Planification et déploiement
```bash
# Voir ce qui va être créé
terraform plan

# Déployer avec variables dev
terraform apply -var-file="vars/dev.tfvars"

# Déployer avec variables staging  
terraform apply -var-file="vars/staging.tfvars"
```

### Gestion des workspaces
```bash
# Créer et utiliser un workspace
terraform workspace new dev
terraform workspace select dev

# Lister les workspaces
terraform workspace list
```

### Nettoyage
```bash
# Détruire l'infrastructure
terraform destroy -var-file="vars/dev.tfvars"
```

## 📋 Prérequis

1. **Terraform installé** (>= 1.0)
2. **AWS CLI configuré** ou credentials dans `provider.tf`
3. **Bucket S3** créé pour le backend (voir `backend.tf`)

## ⚠️ Sécurité

- ❌ **Ne jamais committer de vraies credentials AWS**
- ✅ Utiliser des variables d'environnement ou AWS CLI
- ✅ Activer le chiffrement pour le backend S3
- ✅ Utiliser des workspaces pour séparer les environnements

## 🎯 Ressources créées

Après `terraform apply`, vous aurez :
- ✅ Une instance EC2 Ubuntu
- ✅ Un bucket S3 pour stocker des données
- ✅ Tags automatiques avec l'environnement
- ✅ Outputs avec IDs et URLs des ressources
