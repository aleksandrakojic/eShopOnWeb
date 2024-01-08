variable "db_subnet_group_name" {}
variable "subnet_groups" {}
variable "rds_mysql_sg_id" {}
variable "mysql_db_identifier" {}
variable "mysql_username" {}
variable "mysql_password" {}
variable "mysql_dbname" {}

# RDS Subnet Group
resource "aws_db_subnet_group" "sql_db_subnet_group" {
  name       = var.db_subnet_group_name
  subnet_ids = var.subnet_groups # replace with your private subnet IDs
}

resource "aws_db_instance" "default" {
  allocated_storage       = 10
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t2.micro"
  identifier              = var.mysql_db_identifier
  username                = var.mysql_username
  password                = var.mysql_password
  vpc_security_group_ids  = [var.rds_mysql_sg_id]
  db_subnet_group_name    = aws_db_subnet_group.sql_db_subnet_group.name
  db_name                 = var.mysql_dbname
  skip_final_snapshot     = true
  apply_immediately       = true
  backup_retention_period = 0
  deletion_protection     = false
}

module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = var.mysql_db_identifier

  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3a.medium"
  allocated_storage = 5

  db_name  = var.mysql_dbname
  username = var.mysql_username
  port     = "3306"

  iam_database_authentication_enabled = true

  vpc_security_group_ids = ["sg-12345678"]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval    = "30"
  monitoring_role_name   = "MyRDSMonitoringRole"
  create_monitoring_role = true

  tags = {
    Owner       = "user"
    Environment = "production"
  }

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = ["subnet-12345678", "subnet-87654321"]

  # DB parameter group
  family = "mysql8.0"

  # DB option group
  major_engine_version = "8.0"

  # Database Deletion Protection
  deletion_protection = true

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

}