# ===================================================================
# MODULE VPC - Configuration du réseau principal
# ===================================================================
# Ce module crée une infrastructure réseau complète avec :
# - Un VPC (Virtual Private Cloud) 
# - Des sous-réseaux publics dans différentes zones de disponibilité
# - Tags standardisés avec environnement et workspace
# ===================================================================

# -------------------------------------------------------------------
# VPC Principal
# -------------------------------------------------------------------
# Création du VPC avec un bloc CIDR spécifié
# Le VPC est le réseau virtuel isolé dans AWS
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames  # Permet la résolution DNS des noms d'hôtes
  enable_dns_support   = var.enable_dns_support    # Active le support DNS

  tags = merge(var.common_tags, {
    Name        = var.vpc_name
    Environment = var.environment
  })
}

# -------------------------------------------------------------------
# Sous-réseaux publics 
# -------------------------------------------------------------------
# Création de sous-réseaux publics dans différentes AZ
# count.index permet de créer plusieurs sous-réseaux basés sur la liste
# element() assure une distribution cyclique des AZ
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true  # Assigne automatiquement une IP publique

  tags = merge(var.common_tags, {
    Name        = element(var.public_subnet_names, count.index)
    Environment = var.environment
    Type        = "Public"
    AZ          = element(var.azs, count.index)
  })
}

# -------------------------------------------------------------------
# Sous-réseaux privés 
# -------------------------------------------------------------------
# Création de sous-réseaux privés dans différentes AZ
# Ces sous-réseaux n'ont pas d'accès Internet direct
# Utilisés pour les bases de données, services internes, etc.
resource "aws_subnet" "private" {
  count                   = length(var.private_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = false  # Pas d'IP publique automatique

  tags = merge(var.common_tags, {
    Name        = "Private Subnet ${count.index + 1} - ${element(var.azs, count.index)}"
    Environment = var.environment
    Type        = "Private"
    AZ          = element(var.azs, count.index)
  })
}

# -------------------------------------------------------------------
# Internet Gateway
# -------------------------------------------------------------------
# Passerelle Internet pour permettre l'accès Internet aux sous-réseaux publics
# Nécessaire pour que les instances dans les sous-réseaux publics puissent
# communiquer avec Internet
# Note: L'attachement au VPC se fait automatiquement avec le paramètre vpc_id
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name        = "${var.vpc_name}-igw"
    Environment = var.environment
  })

  # Dépendance explicite pour s'assurer que le VPC existe avant l'IGW
  depends_on = [aws_vpc.main]
}

# -------------------------------------------------------------------
# Table de routage pour sous-réseaux publics
# -------------------------------------------------------------------
# Table de routage qui dirige le trafic vers Internet Gateway
# Toutes les instances dans les sous-réseaux publics utiliseront cette table
resource "aws_route_table" "public" {
  count  = var.enable_internet_gateway && length(var.public_subnet_cidrs) > 0 ? 1 : 0
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.public_route_table_tags,
    {
      Name        = "${var.vpc_name}-public-rt"
      Environment = var.environment
      Type        = "Public"
    }
  )

  # Dépendance explicite pour s'assurer que le VPC existe
  depends_on = [aws_vpc.main]
}

# -------------------------------------------------------------------
# Route vers Internet Gateway pour les sous-réseaux publics
# -------------------------------------------------------------------
# Route par défaut (0.0.0.0/0) vers l'Internet Gateway
# Permet aux instances publiques d'accéder à Internet
resource "aws_route" "public_internet" {
  count                  = var.enable_internet_gateway && length(var.public_subnet_cidrs) > 0 ? 1 : 0
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id

  # Dépendances explicites
  depends_on = [
    aws_route_table.public,
    aws_internet_gateway.main
  ]
}

# -------------------------------------------------------------------
# Table de routage pour sous-réseaux privés
# -------------------------------------------------------------------
# Table de routage pour les sous-réseaux privés (pas d'accès Internet direct)
# Peut être étendue plus tard avec NAT Gateway pour accès Internet sortant
resource "aws_route_table" "private" {
  count  = length(var.private_subnet_cidrs) > 0 ? 1 : 0
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.private_route_table_tags,
    {
      Name        = "${var.vpc_name}-private-rt"
      Environment = var.environment
      Type        = "Private"
    }
  )

  # Dépendance explicite pour s'assurer que le VPC existe
  depends_on = [aws_vpc.main]
}

# -------------------------------------------------------------------
# Association des sous-réseaux publics avec la table de routage publique
# -------------------------------------------------------------------
# Associe chaque sous-réseau public avec la table de routage publique
# Cela permet aux instances publiques d'accéder à Internet
resource "aws_route_table_association" "public" {
  count          = var.enable_internet_gateway && length(var.public_subnet_cidrs) > 0 ? length(var.public_subnet_cidrs) : 0
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public[0].id

  # Dépendances explicites
  depends_on = [
    aws_subnet.public,
    aws_route_table.public
  ]
}

# -------------------------------------------------------------------
# Association des sous-réseaux privés avec la table de routage privée
# -------------------------------------------------------------------
# Associe chaque sous-réseau privé avec la table de routage privée
# Les instances privées n'ont pas d'accès Internet direct
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs) > 0 ? length(var.private_subnet_cidrs) : 0
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[0].id

  # Dépendances explicites
  depends_on = [
    aws_subnet.private,
    aws_route_table.private
  ]
}