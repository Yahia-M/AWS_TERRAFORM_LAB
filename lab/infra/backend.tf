# ===================================================================
# CONFIGURATION DU BACKEND TERRAFORM
# ===================================================================
# Ce fichier configure le stockage distant de l'état Terraform
# Utilise Amazon S3 pour stocker le fichier d'état (.tfstate)
# Permet la collaboration en équipe et la persistence de l'état
# 
# ⚠️ BACKEND S3 TEMPORAIREMENT DÉSACTIVÉ pour résoudre les conflits de version
# Décommentez pour réactiver le backend S3
# ===================================================================

# -------------------------------------------------------------------
# Backend S3 pour l'état Terraform (DÉSACTIVÉ)
# -------------------------------------------------------------------
# Configuration du backend distant pour stocker l'état Terraform
# - bucket: Nom du bucket S3 où stocker l'état
# - key: Chemin/nom du fichier d'état dans le bucket
# - region: Région AWS où se trouve le bucket
# - encrypt: Chiffrement de l'état au repos (recommandé)
# - dynamodb_table: (optionnel) Table DynamoDB pour le verrouillage d'état

# terraform {
#   backend "s3" {
#     bucket = "bucket-backend-lab"          # Bucket S3 pour stocker l'état
#     key    = "terraform/state"             # Chemin du fichier d'état
#     region = "us-east-1"                   # Région du bucket S3
#     //dynamodb_table = "terraform-locks"  # Table pour le verrouillage (à décommenter si nécessaire)
#     encrypt = true                         # Chiffrement de l'état
#   }
# }

# -------------------------------------------------------------------
# ÉTAT LOCAL TEMPORAIRE
# -------------------------------------------------------------------
# L'état sera stocké localement dans terraform.tfstate
# Pour réactiver S3, décommentez le bloc ci-dessus et relancez terraform init