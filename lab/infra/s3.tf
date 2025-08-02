# ===================================================================
# CONFIGURATION DES BUCKETS S3
# ===================================================================
# Ce fichier définit les buckets Amazon S3 pour le stockage d'objets
# S3 = Simple Storage Service - stockage évolutif et sécurisé
# Tags automatiques pour organiser et suivre les coûts
# Gestion intelligente des buckets existants
# ===================================================================

# -------------------------------------------------------------------
# Data Source : Vérifier si le bucket existe déjà
# -------------------------------------------------------------------
# Cette data source permet de vérifier l'existence du bucket
# sans provoquer d'erreur si il existe déjà
data "aws_s3_bucket" "existing_bucket" {
  count  = var.use_existing_bucket ? 1 : 0
  bucket = var.bucket_name
}

# -------------------------------------------------------------------
# Bucket S3 pour les données (création conditionnelle)
# -------------------------------------------------------------------
# Création d'un bucket S3 seulement s'il n'existe pas déjà
# - bucket: Nom unique global du bucket (doit être unique dans tout AWS)
# - tags: Métadonnées pour l'organisation et la facturation
# 
# Note: Les noms de buckets S3 doivent être uniques globalement
# et suivre les conventions de nommage DNS
resource "aws_s3_bucket" "data_bucket" {
  count  = var.use_existing_bucket ? 0 : 1
  bucket = var.bucket_name # Nom du bucket (doit être unique)

  # Tags pour identifier et organiser le bucket
  tags = merge(var.common_tags, {
    Name        = "DataBucket-${terraform.workspace}" # Nom descriptif avec workspace
    Environment = terraform.workspace                 # Environnement (dev, staging, prod)
    ManagedBy   = "Terraform"                         # Indique la gestion par Terraform
  })
}

# -------------------------------------------------------------------
# Local : Référence unifiée au bucket
# -------------------------------------------------------------------
# Permet d'utiliser le même nom de référence que le bucket
# soit existant (data source) ou créé (resource)
locals {
  bucket_id  = var.use_existing_bucket ? data.aws_s3_bucket.existing_bucket[0].id : aws_s3_bucket.data_bucket[0].id
  bucket_arn = var.use_existing_bucket ? data.aws_s3_bucket.existing_bucket[0].arn : aws_s3_bucket.data_bucket[0].arn
}

# ===================================================================
# VARIABLES D'ENTRÉE
# ===================================================================

# -------------------------------------------------------------------
# Variable : Nom du bucket S3
# -------------------------------------------------------------------
# Nom du bucket S3 à créer ou utiliser
# IMPORTANT: Doit être unique globalement dans tout AWS
# Conventions: minuscules, tirets autorisés, pas de points
variable "bucket_name" {
  description = "The name of the S3 bucket to create or use"
  type        = string

  # Validation du nom de bucket
  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.bucket_name)) && length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "Bucket name must be between 3-63 characters, lowercase, start/end with alphanumeric, and contain only lowercase letters, numbers, and hyphens."
  }
}

# -------------------------------------------------------------------
# Variable : Utiliser un bucket existant
# -------------------------------------------------------------------
# Détermine si on utilise un bucket existant ou si on en crée un nouveau
variable "use_existing_bucket" {
  description = "Whether to use an existing bucket instead of creating a new one"
  type        = bool
  default     = true # Par défaut, essaie d'utiliser un bucket existant
}