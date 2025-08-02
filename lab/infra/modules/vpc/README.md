# Module VPC - Infrastructure Réseau AWS

Ce module Terraform crée une infrastructure réseau complète sur AWS avec VPC, sous-réseaux publics et privés.

## 🏗️ Ressources créées

### **VPC (Virtual Private Cloud)**
- ✅ VPC principal avec CIDR configurable
- ✅ DNS hostnames et support activés
- ✅ Tags standardisés

### **Sous-réseaux**
- ✅ **Sous-réseaux publics** - Accès Internet direct
- ✅ **Sous-réseaux privés** - Pas d'accès Internet direct
- ✅ Distribution automatique sur différentes zones de disponibilité
- ✅ IP publiques automatiques pour les sous-réseaux publics

### **Connectivité Internet**
- ✅ **Internet Gateway** - Accès Internet pour sous-réseaux publics
- ✅ **Tables de routage** - Publiques et privées
- ✅ **Associations** - Liaison sous-réseaux/tables de routage

## 📋 Variables d'entrée

| Variable | Type | Défaut | Description |
|----------|------|--------|-------------|
| `cidr_block` | string | `10.0.0.0/16` | CIDR du VPC |
| `public_subnet_cidrs` | list(string) | `["10.0.1.0/24", "10.0.2.0/24"]` | CIDRs des sous-réseaux publics |
| `private_subnet_cidrs` | list(string) | `["10.0.3.0/24", "10.0.4.0/24"]` | CIDRs des sous-réseaux privés |
| `azs` | list(string) | `["us-east-1a", "us-east-1b"]` | Zones de disponibilité |
| `vpc_name` | string | `main-vpc` | Nom du VPC |
| `environment` | string | `dev` | Environnement (dev/staging/prod) |

## 📤 Valeurs de sortie

| Output | Description |
|--------|-------------|
| `vpc_id` | ID du VPC créé |
| `public_subnet_ids` | IDs des sous-réseaux publics |
| `private_subnet_ids` | IDs des sous-réseaux privés |
| `internet_gateway_id` | ID de l'Internet Gateway |
| `public_route_table_id` | ID de la table de routage publique |
| `private_route_table_id` | ID de la table de routage privée |

## 🚀 Utilisation

### **Utilisation basique**
```terraform
module "vpc" {
  source = "./modules/vpc"
  
  cidr_block = "10.0.0.0/16"
  vpc_name   = "my-vpc"
  environment = "dev"
}
```

### **Configuration avancée**
```terraform
module "vpc" {
  source = "./modules/vpc"
  
  cidr_block           = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
  azs                  = ["us-east-1a", "us-east-1b", "us-east-1c"]
  
  vpc_name    = "production-vpc"
  environment = "prod"
  
  common_tags = {
    Project   = "MyApp"
    Owner     = "DevOps"
    Terraform = "true"
  }
}
```

### **Référencer les outputs**
```terraform
# Utiliser le VPC dans d'autres ressources
resource "aws_instance" "web" {
  subnet_id = module.vpc.public_subnet_ids[0]
  # ... autres configurations
}

# Base de données dans sous-réseau privé
resource "aws_db_subnet_group" "main" {
  subnet_ids = module.vpc.private_subnet_ids
  # ... autres configurations
}
```

## 🏛️ Architecture

```
VPC (10.0.0.0/16)
├── Public Subnet 1 (10.0.1.0/24) - us-east-1a
├── Public Subnet 2 (10.0.2.0/24) - us-east-1b
├── Private Subnet 1 (10.0.3.0/24) - us-east-1a
├── Private Subnet 2 (10.0.4.0/24) - us-east-1b
├── Internet Gateway
├── Public Route Table → Internet Gateway
└── Private Route Table (local only)
```

## 🎯 Cas d'usage

### **Sous-réseaux publics**
- ✅ Serveurs web
- ✅ Load balancers
- ✅ Bastion hosts
- ✅ NAT Gateways

### **Sous-réseaux privés**
- ✅ Bases de données
- ✅ Serveurs d'application
- ✅ Services internes
- ✅ Microservices

## 🔒 Sécurité

- ✅ **Isolation réseau** - Sous-réseaux privés sans accès Internet
- ✅ **Zones multiples** - Haute disponibilité
- ✅ **Routage contrôlé** - Tables de routage séparées
- ✅ **Tags standardisés** - Traçabilité et facturation
