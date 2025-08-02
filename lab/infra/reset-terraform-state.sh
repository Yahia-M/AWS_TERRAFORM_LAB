#!/bin/bash

# ===================================================================
# SCRIPT DE RESET COMPLET DE L'ÉTAT TERRAFORM
# ===================================================================
# Ce script supprime complètement l'état et redémarre à zéro
# ⚠️ ATTENTION: Cela supprimera toutes les informations d'état
# ===================================================================

set -e

echo "⚠️  ATTENTION: Ce script va supprimer complètement l'état Terraform"
echo "Cela signifie que Terraform ne saura plus quelles ressources il gère."
echo ""
echo "Options disponibles:"
echo "1. Continuer et supprimer l'état (recommandé pour les labs)"
echo "2. Créer un nouvel environnement avec un nouveau backend"
echo "3. Annuler"
echo ""

read -p "Choisissez une option (1/2/3): " choice

case $choice in
    1)
        echo "🗑️  Suppression de l'état existant..."
        
        # Supprimer les fichiers locaux
        rm -rf .terraform/
        rm -f .terraform.lock.hcl
        rm -f terraform.tfstate*
        
        # Créer un nouveau backend avec un nom différent
        TIMESTAMP=$(date +%Y%m%d_%H%M%S)
        NEW_BUCKET="bucket-backend-lab-${TIMESTAMP}"
        
        echo "📦 Création d'un nouveau backend: ${NEW_BUCKET}"
        
        # Sauvegarder l'ancien backend.tf
        cp backend.tf backend.tf.backup
        
        # Créer un nouveau backend.tf
        cat > backend.tf << EOF
# ===================================================================
# NOUVEAU BACKEND TERRAFORM - ${TIMESTAMP}
# ===================================================================
# Backend réinitialisé pour éviter les conflits de version
# ===================================================================

terraform {
  backend "s3" {
    bucket = "${NEW_BUCKET}"
    key    = "terraform/state"
    region = "us-east-1"
    encrypt = true
  }
}
EOF
        
        echo "✅ Nouveau backend configuré"
        echo "⚠️  Note: Vous devez créer le bucket S3 '${NEW_BUCKET}' manuellement"
        echo ""
        echo "Commandes à exécuter:"
        echo "1. aws s3 mb s3://${NEW_BUCKET}"
        echo "2. terraform init"
        echo "3. terraform plan -var-file=\"vars/staging.tfvars\""
        ;;
    
    2)
        echo "🆕 Création d'un environnement local..."
        
        # Supprimer les fichiers locaux
        rm -rf .terraform/
        rm -f .terraform.lock.hcl
        
        # Commenter le backend pour utiliser l'état local
        cp backend.tf backend.tf.backup
        sed 's/^/# /' backend.tf > backend.tf.tmp && mv backend.tf.tmp backend.tf
        
        echo "✅ Backend local configuré"
        echo "État sera stocké localement dans terraform.tfstate"
        ;;
    
    3)
        echo "❌ Opération annulée"
        exit 0
        ;;
    
    *)
        echo "❌ Option invalide"
        exit 1
        ;;
esac

echo ""
echo "🎉 Configuration terminée !"
