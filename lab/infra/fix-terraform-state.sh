#!/bin/bash

# ===================================================================
# SCRIPT DE RÉSOLUTION DES PROBLÈMES TERRAFORM
# ===================================================================
# Ce script résout les problèmes courants de compatibilité Terraform
# Utilisation: ./fix-terraform-state.sh
# ===================================================================

set -e  # Arrêter en cas d'erreur

echo "🔧 Résolution des problèmes Terraform..."

# -------------------------------------------------------------------
# 1. Sauvegarde de l'état actuel
# -------------------------------------------------------------------
echo "📦 Sauvegarde de l'état Terraform..."
if [ -f "terraform.tfstate" ]; then
    cp terraform.tfstate terraform.tfstate.backup.$(date +%Y%m%d_%H%M%S)
    echo "✅ État sauvegardé"
else
    echo "ℹ️  Aucun état local trouvé"
fi

# -------------------------------------------------------------------
# 2. Nettoyage des fichiers temporaires
# -------------------------------------------------------------------
echo "🧹 Nettoyage des fichiers temporaires..."
rm -rf .terraform/
rm -f .terraform.lock.hcl
echo "✅ Fichiers temporaires supprimés"

# -------------------------------------------------------------------
# 3. Réinitialisation de Terraform
# -------------------------------------------------------------------
echo "🔄 Réinitialisation de Terraform..."
terraform init -upgrade
echo "✅ Terraform réinitialisé"

# -------------------------------------------------------------------
# 4. Validation de la configuration
# -------------------------------------------------------------------
echo "✅ Validation de la configuration..."
terraform validate
echo "✅ Configuration validée"

# -------------------------------------------------------------------
# 5. Plan avec le fichier de variables staging
# -------------------------------------------------------------------
echo "📋 Test du plan avec staging.tfvars..."
if terraform plan -var-file="vars/staging.tfvars" -detailed-exitcode; then
    echo "✅ Plan réussi - Aucun changement nécessaire"
elif [ $? -eq 2 ]; then
    echo "ℹ️  Plan réussi - Des changements sont proposés"
else
    echo "❌ Erreur dans le plan"
    exit 1
fi

echo ""
echo "🎉 Résolution terminée !"
echo ""
echo "📋 Prochaines étapes recommandées :"
echo "1. Vérifiez le plan : terraform plan -var-file=\"vars/staging.tfvars\""
echo "2. Appliquez si tout est correct : terraform apply -var-file=\"vars/staging.tfvars\""
echo "3. Ou détruisez l'infrastructure existante : terraform destroy -var-file=\"vars/staging.tfvars\""
