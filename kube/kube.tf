# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.32.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "~> 2.17.0"
    }
  }
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
      rolearn = component.cluster.outputs.admin_arn
      username = "eks-admin"
      groups = [
        "system:masters"
      ]
      }
    ])
  
}
}
resource "kubernetes_namespace_v1" "demo_ns" {
  metadata {
    name = "demo-ns"
  }
}

resource "kubernetes_manifest" "demo_workspace" {
  manifest = {
    apiVersion = "app.terraform.io/v1alpha2"
    kind       = kubernetes_manifest.crd_workspaces.object.spec.names.kind
    metadata = {
      name      = "deferred-demo"
      namespace = kubernetes_namespace_v1.demo_ns.id
    }
    spec = {
      name         = "demo-ws"
      organization = "demo-org"
      token = {
        secretKeyRef = {
          name = "demo-token"
          key  = "token"
        }
      }
    }
  }
}
resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "7.8.26" # check for the latest

  create_namespace = true

  values = [
    file("${path.module}/values-argocd.yaml")
  ]
}
data "kubernetes_service" "argocd_server" {
  metadata {
    name      = "argocd-server"
    namespace = "argocd"
  }
}

output "argocd_url" {
  value = data.kubernetes_service.argocd_server.status.0.load_balancer.0.ingress.0.hostname
}



