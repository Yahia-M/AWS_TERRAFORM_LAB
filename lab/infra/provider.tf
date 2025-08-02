# ===================================================================
# CONFIGURATION DU PROVIDER AWS
# ===================================================================
# Ce fichier configure le provider AWS pour Terraform
# Définit la région et utilise les credentials depuis l'environnement
# ⚠️  SÉCURITÉ: Les credentials sont configurées via variables d'environnement
# ===================================================================

# -------------------------------------------------------------------
# Provider AWS
# -------------------------------------------------------------------
# Configuration du provider AWS avec region
# Les credentials sont automatiquement récupérées depuis:
# - Variables d'environnement: AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY
# - Profil AWS CLI par défaut ou spécifié via AWS_PROFILE
# - Rôles IAM si exécuté sur EC2/ECS/Lambda
provider "aws" {
  region = "us-east-1" # Région AWS par défaut
  # Credentials automatiquement récupérées depuis l'environnement
}
