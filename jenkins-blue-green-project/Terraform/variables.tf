variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "security_group_name" {
  description = "Name of the security group"
  type        = string
  default     = "cicd-security-group"
}

variable "key_name" {
  description = "Name of the AWS key pair"
  type        = string
}

variable "jenkins_instance_type" {
  description = "Instance type for Jenkins server"
  type        = string
  default     = "t2.small"
}

variable "prod_instance_type" {
  description = "Instance type for production server"
  type        = string
  default     = "t2.micro"
}