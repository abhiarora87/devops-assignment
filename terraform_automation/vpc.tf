module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "ecs-vpc"
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  create_igw             = true
  enable_nat_gateway     = true
  create_egress_only_igw = true
  single_nat_gateway     = true
}
