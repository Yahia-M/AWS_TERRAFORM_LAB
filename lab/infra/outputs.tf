# ===================================================================
# OUTPUTS - VALEURS DE SORTIE
# ===================================================================
# Ce fichier définit les valeurs de sortie de notre infrastructure
# Les outputs permettent d'exposer des informations importantes
# après le déploiement (IDs, URLs, etc.)
# ===================================================================

# -------------------------------------------------------------------
# Output : ID de l'instance EC2
# -------------------------------------------------------------------
# Expose l'ID de l'instance EC2 créée
# Utile pour référencer l'instance dans d'autres configurations
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.example.id
}

# -------------------------------------------------------------------
# Output : IP publique de l'instance EC2
# -------------------------------------------------------------------
# Expose l'adresse IP publique de l'instance
# Utile pour se connecter à l'instance ou configurer DNS
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.example.public_ip
}

# -------------------------------------------------------------------
# Output : Nom du bucket S3
# -------------------------------------------------------------------
# Expose le nom du bucket S3 utilisé (existant ou créé)
# Utile pour les applications qui doivent interagir avec le bucket
output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = var.bucket_name
}

# -------------------------------------------------------------------
# Output : ARN du bucket S3
# -------------------------------------------------------------------
# Expose l'ARN (Amazon Resource Name) du bucket
# Nécessaire pour les politiques IAM et intégrations
output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = local.bucket_arn
}

# -------------------------------------------------------------------
# Output : ID du bucket S3
# -------------------------------------------------------------------
# Expose l'ID du bucket S3 (même que le nom pour S3)
output "s3_bucket_id" {
  description = "ID of the S3 bucket"
  value       = local.bucket_id
}

# -------------------------------------------------------------------
# Output : Source du bucket
# -------------------------------------------------------------------
# Indique si le bucket a été créé ou s'il existait déjà
output "s3_bucket_source" {
  description = "Whether the bucket was created or already existed"
  value       = var.use_existing_bucket ? "existing" : "created"
}

# -------------------------------------------------------------------
# Output : Workspace actuel
# -------------------------------------------------------------------
# Expose le workspace Terraform utilisé
# Utile pour identifier l'environnement déployé
output "terraform_workspace" {
  description = "Current Terraform workspace"
  value       = terraform.workspace
}
