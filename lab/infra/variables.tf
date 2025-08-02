# ===================================================================
# VARIABLES GLOBALES DU PROJET
# ===================================================================
# Ce fichier centralise toutes les variables globales du projet
# Sépare la déclaration des variables de leurs valeurs par défaut
# Les valeurs spécifiques sont dans les fichiers .tfvars
# ===================================================================

# -------------------------------------------------------------------
# Variables AWS - Région et Configuration
# -------------------------------------------------------------------

variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.aws_region))
    error_message = "AWS region must be in valid format (e.g., us-east-1, eu-west-1)."
  }
}

# -------------------------------------------------------------------
# Variables Projet - Métadonnées
# -------------------------------------------------------------------

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "aws-terraform-lab"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "terraform-lab"
}

# -------------------------------------------------------------------
# Variables Communes - Tags
# -------------------------------------------------------------------

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Project   = "AWS-Terraform-Lab"
    ManagedBy = "Terraform"
    Owner     = "DevOps-Team"
  }
}

# -------------------------------------------------------------------
# Variables Réseau - VPC et Subnets (si module VPC utilisé)
# -------------------------------------------------------------------

variable "enable_vpc_module" {
  description = "Whether to create VPC using module"
  type        = bool
  default     = false
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "VPC CIDR must be a valid IPv4 CIDR block."
  }
}
