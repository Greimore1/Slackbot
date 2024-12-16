variable "container_image" {
  description = "ECR container image"
  type        = string
}
variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}
variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}
