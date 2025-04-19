# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "cluster_name" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "workers_count" {
  type    = number
  default = "1"
}

variable "region" {
  type = string
}
variable "admin_arn" {
  type = string
}
variable "admin_role_name" {
  type = string
}