# ===================================================================
# CONFIGURATION DES INSTANCES EC2
# ===================================================================
# Ce fichier définit les instances EC2 (machines virtuelles)
# Utilise des variables pour la flexibilité et la réutilisabilité
# Tags automatiques avec le workspace pour différencier les environnements
# ===================================================================

# -------------------------------------------------------------------
# Instance EC2 principale
# -------------------------------------------------------------------
# Création d'une instance EC2 avec configuration personnalisable
# - ami: Image système (Amazon Machine Image) à utiliser
# - instance_type: Type/taille de l'instance (CPU, RAM, réseau)
# - tags: Métadonnées pour identifier et organiser les ressources
resource "aws_instance" "example" {
  ami           = var.ami_id        # ID de l'AMI à utiliser
  instance_type = var.instance_type # Type d'instance (t2.micro, t3.small, etc.)
  //instance_type = "t2.micro"                     # Alternative hardcodée (commentée)

  # Tags pour identifier l'instance
  tags = {
    Name = "ExampleInstance-${terraform.workspace}" # Nom avec workspace pour différenciation
  }
}

# ===================================================================
# VARIABLES D'ENTRÉE
# ===================================================================

# -------------------------------------------------------------------
# Variable : ID de l'AMI
# -------------------------------------------------------------------
# ID de l'Amazon Machine Image à utiliser pour l'instance
# Par défaut : Ubuntu Server 22.04 LTS (us-east-1)
variable "ami_id" {
  description = "The AMI ID to use for the instance"
  type        = string
  default     = "ami-08a6efd148b1f7504" # Ubuntu 22.04 LTS en us-east-1
}

# -------------------------------------------------------------------
# Variable : Type d'instance
# -------------------------------------------------------------------
# Définit la taille et les capacités de l'instance EC2
# t2.micro est éligible au Free Tier AWS
variable "instance_type" {
  description = "The instance type to use for the instance"
  type        = string
  default     = "t2.micro" # Free Tier éligible
}