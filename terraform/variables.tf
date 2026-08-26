variable "instance_type" {
  description = "Tipo da instancia EC2"
  type        = string
  default     = "t3.small"
}

variable "instance_name" {
  description = "Nome (tag Name) da instancia EC2"
  type        = string
  default     = "nginx-public"
}

variable "security_group_name" {
  description = "Nome do Security Group"
  type        = string
  default     = "nginx-public-sg"
}

variable "project_name" {
  description = "Nome do projeto para tagging"
  type        = string
  default     = "nginx-public"
}
