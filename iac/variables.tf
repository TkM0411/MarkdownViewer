variable "aws_region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "project" {
  type        = string
  description = "Project"
  default     = "MarkdownViewer"
}

variable "project_owner" {
  type        = string
  description = "Owner of resources in the project"
  default     = "TkM"
}

variable "custom_domain_name" {
  type        = string
  description = "Custom Domain Name for hosting"
  default     = "tkmworks.co.in"
}