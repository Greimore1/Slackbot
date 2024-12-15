variable "TF_VAR_SUBNET_IDS" {
  description = "Subnets for ECS service"
  type        = list(string)
}

variable "TF_VAR_SECURITY_GROUP_IDS" {
  description = "Security groups for ECS service"
  type        = list(string)
}
