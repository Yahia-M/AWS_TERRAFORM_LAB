module "vpc" {
  source = "./modules/vpc"

  cidr_block              = "10.0.0.0/16"
  public_subnet_cidrs     = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs    = ["10.0.3.0/24", "10.0.4.0/24"]
  azs                     = ["us-east-1a", "us-east-1b"]
  vpc_name                = "main-vpc"
  enable_internet_gateway = true
  common_tags             = var.common_tags

}