# ===================================================================
# VARIABLES DU MODULE VPC
# ===================================================================
# Ce fichier définit toutes les variables d'entrée du module VPC
# Séparation claire entre la déclaration des variables et leur utilisation
# ===================================================================

# -------------------------------------------------------------------
# Variable : CIDR Block du VPC
# -------------------------------------------------------------------
variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
  
  validation {
    condition = can(cidrhost(var.cidr_block, 0))
    error_message = "CIDR block must be a valid IPv4 CIDR."
  }
}

# -------------------------------------------------------------------
# Variable : CIDR des sous-réseaux publics
# -------------------------------------------------------------------
variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
  
  validation {
    condition = length(var.public_subnet_cidrs) >= 0
    error_message = "Public subnet CIDRs list must be valid."
  }
  
  validation {
    condition = alltrue([
      for cidr in var.public_subnet_cidrs : can(cidrhost(cidr, 0))
    ])
    error_message = "All public subnet CIDRs must be valid IPv4 CIDR blocks."
  }
}

# -------------------------------------------------------------------
# Variable : Zones de disponibilité
# -------------------------------------------------------------------
variable "azs" {
  description = "List of availability zones to use for subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
  
  validation {
    condition = length(var.azs) > 0
    error_message = "At least one availability zone must be provided."
  }
}

# -------------------------------------------------------------------
# Variable : Nom du VPC
# -------------------------------------------------------------------
variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "main-vpc"
}

# -------------------------------------------------------------------
# Variable : Noms des sous-réseaux publics
# -------------------------------------------------------------------
variable "public_subnet_names" {
  description = "List of names for public subnets"
  type        = list(string)
  default     = ["Public Subnet 1", "Public Subnet 2"]
}

# -------------------------------------------------------------------
# Variable : CIDR des sous-réseaux privés
# -------------------------------------------------------------------
# Liste des blocs CIDR pour les sous-réseaux privés
# Les sous-réseaux privés n'ont pas d'accès Internet direct
# Utilisés pour les bases de données, services internes, etc.
variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
  
  validation {
    condition = length(var.private_subnet_cidrs) >= 0
    error_message = "Private subnet CIDRs list must be valid (can be empty)."
  }
  
  validation {
    condition = alltrue([
      for cidr in var.private_subnet_cidrs : can(cidrhost(cidr, 0))
    ])
    error_message = "All private subnet CIDRs must be valid IPv4 CIDR blocks."
  }
}

# -------------------------------------------------------------------
# Variable : Tags communs
# -------------------------------------------------------------------
variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Terraform = "true"
    Module    = "vpc"
  }
}

# -------------------------------------------------------------------
# Variable : Environnement
# -------------------------------------------------------------------
variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

# -------------------------------------------------------------------
# Variable : Noms des sous-réseaux privés
# -------------------------------------------------------------------
variable "private_subnet_names" {
  description = "List of names for private subnets"
  type        = list(string)
  default     = ["Private Subnet 1", "Private Subnet 2"]
}

# -------------------------------------------------------------------
# Variable : Activation DNS
# -------------------------------------------------------------------
variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

# -------------------------------------------------------------------
# Variable : Routes personnalisées
# -------------------------------------------------------------------
variable "enable_internet_gateway" {
  description = "Enable Internet Gateway creation"
  type        = bool
  default     = true
}

variable "public_route_table_tags" {
  description = "Additional tags for public route table"
  type        = map(string)
  default     = {}
}

variable "private_route_table_tags" {
  description = "Additional tags for private route table"  
  type        = map(string)
  default     = {}
}

# -------------------------------------------------------------------
# Variable : Validation des CIDRs
# -------------------------------------------------------------------
variable "validate_subnet_cidrs" {
  description = "Validate that subnet CIDRs are within VPC CIDR"
  type        = bool
  default     = true
}
