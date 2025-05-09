# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "cluster_name" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "region" {
  type = string
}

variable "role_arn" {
  type = string
}

variable "identity_token" {
  type      = string
  ephemeral = true
}

variable "default_tags" {
  description = "A map of default tags to apply to all AWS resources"
  type        = map(string)
  default     = {}
}
variable "admin_arn" {
  type = string  
}
variable "admin_role_name" {
  type = string 
}
