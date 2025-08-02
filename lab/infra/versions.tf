# ===================================================================
# VERSIONS DES PROVIDERS ET TERRAFORM
# ===================================================================
# Ce fichier spécifie les versions minimales requises de Terraform
# et des providers utilisés pour assurer la compatibilité
# Bonne pratique : toujours fixer les versions en production
# ===================================================================

# -------------------------------------------------------------------
# Version Terraform requise
# -------------------------------------------------------------------
terraform {
  # Version minimale de Terraform requise
  required_version = ">= 1.0"

  # -------------------------------------------------------------------
  # Providers requis avec leurs versions
  # -------------------------------------------------------------------
  required_providers {
    # Provider AWS - Version la plus récente pour compatibilité
    aws = {
      source  = "hashicorp/aws" # Source officielle HashiCorp
      version = "~> 5.82"       # Version la plus récente compatible
    }

    # Provider Random (pour générer des valeurs aléatoires)
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }

    # Provider Local (pour fichiers locaux)
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

# ===================================================================
# CONFIGURATION DU PROVIDER AWS (FEATURES)
# ===================================================================
# Configuration des fonctionnalités spécifiques du provider AWS
# Permet d'activer/désactiver certaines fonctionnalités

# Note: Les credentials AWS sont configurés dans provider.tf
# Ici on configure seulement les fonctionnalités du provider
