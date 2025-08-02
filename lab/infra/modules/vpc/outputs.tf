# ===================================================================
# OUTPUTS DU MODULE VPC
# ===================================================================
# Ce fichier expose les valeurs importantes du module VPC
# Ces outputs peuvent être utilisés par d'autres modules ou ressources
# ===================================================================

# -------------------------------------------------------------------
# Output : ID du VPC
# -------------------------------------------------------------------
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

# -------------------------------------------------------------------
# Output : CIDR du VPC
# -------------------------------------------------------------------
output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

# -------------------------------------------------------------------
# Output : IDs des sous-réseaux publics
# -------------------------------------------------------------------
output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

# -------------------------------------------------------------------
# Output : IDs des sous-réseaux privés
# -------------------------------------------------------------------
output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

# -------------------------------------------------------------------
# Output : CIDRs des sous-réseaux publics
# -------------------------------------------------------------------
output "public_subnet_cidrs" {
  description = "CIDR blocks of the public subnets"
  value       = aws_subnet.public[*].cidr_block
}

# -------------------------------------------------------------------
# Output : CIDRs des sous-réseaux privés
# -------------------------------------------------------------------
output "private_subnet_cidrs" {
  description = "CIDR blocks of the private subnets"
  value       = aws_subnet.private[*].cidr_block
}

# -------------------------------------------------------------------
# Output : Zones de disponibilité des sous-réseaux publics
# -------------------------------------------------------------------
output "public_availability_zones" {
  description = "Availability zones of the public subnets"
  value       = aws_subnet.public[*].availability_zone
}

# -------------------------------------------------------------------
# Output : Zones de disponibilité des sous-réseaux privés
# -------------------------------------------------------------------
output "private_availability_zones" {
  description = "Availability zones of the private subnets"
  value       = aws_subnet.private[*].availability_zone
}

# -------------------------------------------------------------------
# Output : ID de l'Internet Gateway
# -------------------------------------------------------------------
output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

# -------------------------------------------------------------------
# Output : ID de la table de routage publique
# -------------------------------------------------------------------
output "public_route_table_id" {
  description = "ID of the public route table"
  value       = var.enable_internet_gateway && length(var.public_subnet_cidrs) > 0 ? aws_route_table.public[0].id : null
}

# -------------------------------------------------------------------
# Output : ID de la table de routage privée
# -------------------------------------------------------------------
output "private_route_table_id" {
  description = "ID of the private route table"
  value       = length(var.private_subnet_cidrs) > 0 ? aws_route_table.private[0].id : null
}
