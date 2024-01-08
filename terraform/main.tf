data "aws_availability_zones" "azs" {}

module "eks-vpc" {
  source          = "terraform-aws-modules/vpc/aws"
  version         = "5.0.0"
  name            = var.vpc_name
  cidr            = var.vpc_cidr
  private_subnets = var.cidr_private_subnet
  public_subnets  = var.cidr_public_subnet
  azs             = data.aws_availability_zones.azs.names

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/eshop-eks-cluster" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/eshop-eks-cluster" = "shared"
    "kubernetes.io/role/elb"                  = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/eshop-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb"         = 1
  }
}

module "eks" {
    source  = "terraform-aws-modules/eks/aws"
    version = "~> 19.21"

    cluster_name = "eshop-eks-cluster"
    cluster_version = "1.28"

    cluster_endpoint_public_access  = true

    vpc_id = module.eks-vpc.vpc_id
    subnet_ids = module.eks-vpc.private_subnets

    tags = {
        environment = "production"
        application = "eshop-server"
    }

    eks_managed_node_groups = {
        dev = {
            min_size = 1
            max_size = 3
            desired_size = 2

            instance_types = ["t2.medium"]
        }
    }
}


# module "lb_target_group" {
#   source                   = "./load-balancer-target-group"
#   lb_target_group_name     = "devops-lb-target-group"
#   lb_target_group_port     = 5000
#   lb_target_group_protocol = "HTTP"
#   vpc_id                   = module.networking.devops_vpc_id
#   ec2_instance_id          = module.ec2.devops_ec2_instance_id
# }

# module "alb" {
#   source                    = "./load-balancer"
#   lb_name                   = "devops-alb"
#   is_external               = false
#   lb_type                   = "application"
#   sg_enable_ssh_https       = module.security_group.sg_ec2_sg_ssh_http_id
#   subnet_ids                = tolist(module.networking.devops_public_subnets)
#   tag_name                  = "devops-alb"
#   lb_target_group_arn       = module.lb_target_group.devops_lb_target_group_arn
#   ec2_instance_id           = module.ec2.devops_ec2_instance_id
#   lb_listner_port           = 5000
#   lb_listner_protocol       = "HTTP"
#   lb_listner_default_action = "forward"
#   lb_https_listner_port     = 443
#   lb_https_listner_protocol = "HTTPS"
#   devops_acm_arn        = module.aws_ceritification_manager.devops_acm_arn
#   lb_target_group_attachment_port = 5000
# }

# module "hosted_zone" {
#   source          = "./hosted-zone"
#   domain_name     = var.domain_name
#   aws_lb_dns_name = module.alb.aws_lb_dns_name
#   aws_lb_zone_id  = module.alb.aws_lb_zone_id
# }

# module "aws_ceritification_manager" {
#   source         = "./certificate-manager"
#   domain_name    = var.domain_name
#   hosted_zone_id = module.hosted_zone.hosted_zone_id
# }

# module "rds_db_instance" {
#   source               = "./rds"
#   db_subnet_group_name = "devops_rds_subnet_group"
#   subnet_groups        = tolist(module.networking.devops_public_subnets)
#   rds_mysql_sg_id      = module.security_group.rds_mysql_sg_id
#   mysql_db_identifier  = "mydb"
#   mysql_username       = "dbuser"
#   mysql_password       = "dbpassword"
#   mysql_dbname         = "devprojdb"
# }