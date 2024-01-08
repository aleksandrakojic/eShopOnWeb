variable "bucket_name" {
  type        = string
  description = "Remote state bucket name"
}

variable "vpc_cidr" {
  type        = string
  description = "Public Subnet CIDR values"
}

variable "vpc_name" {
  type        = string
  description = "DevOps Project VPC 1"
}

variable "cidr_public_subnet" {
  type        = list(string)
  description = "Public Subnet CIDR values"
}

variable "cidr_private_subnet" {
  type        = list(string)
  description = "Private Subnet CIDR values"
}

variable "eu_availability_zone" {
  type        = list(string)
  description = "Availability Zones"
}

variable "public_key" {
  type        = string
  description = "DevOps Project Public key for EC2 instance"
}

variable "ec2_ami_id" {
  type        = string
  description = "DevOps Project AMI Id for EC2 instance"
}

variable "domain_name" {
  type        = string
  description = "Domain name for Route53"
}

variable "cluster_name" {
  type        = string
  description = "EKS Cluster name"
}

variable "mysql_password" {
  type        = string
  description = "MySQL password"
}

variable "mysql_db_identifier" {
  type        = string
  description = "MySQL DB identifier"
}

variable "mysql_username" {
  type        = string
  description = "MySQL username"
}

variable "mysql_dbname" {
  type        = string
  description = "MySQL DB name"
}
