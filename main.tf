resource "kubernetes_namespace" "this" {
  count = var.namespace == "default" ? 1 - local.argocd_enabled : 0
  metadata {
    name = var.namespace_name
  }
}

resource "helm_release" "app" {
  count      = 1 - local.argocd_enabled + var.force_argocd
  name       = local.name
  repository = var.repository
  chart      = var.chart
  version    = var.chart_version
  namespace  = local.namespace
  timeout    = 1200
  values     = [var.values]

  lifecycle {
    ignore_changes = [set, version, values]
  }
}

resource "local_file" "app" {
  count    = local.argocd_enabled
  content  = data.utils_deep_merge_yaml.merged.output
  filename = "${var.argocd.path}/${local.name}.yaml"
}

data "utils_deep_merge_yaml" "merged" {
  input = [
    yamlencode(local.app),
    yamlencode(var.argocd_custom_app_settings)
  ]
  deep_copy_list = true
}

locals {
  name           = var.name == "" ? var.chart : var.name
  argocd_enabled = length(var.argocd) > 0 ? 1 : var.force_argocd
  namespace      = coalescelist(kubernetes_namespace.this, [{ "metadata" = [{ "name" = var.namespace }] }])[0].metadata[0].name
  app = {
    "apiVersion" = "argoproj.io/v1alpha1"
    "kind"       = "Application"
    "metadata" = {
      "name"      = local.name
      "namespace" = var.argocd.namespace
    }
    "spec" = {
      "destination" = {
        "namespace" = local.namespace
        "server"    = var.destination_server
      }
      "project" = var.project == "" ? var.argocd.project : var.project
      "source" = {
        "repoURL"        = var.repository
        "targetRevision" = var.chart_version
        "chart"          = var.chart
        "helm" = {
          "values" = var.values
        }
      }
      "syncPolicy" = {
        "syncOptions" = [
          "CreateNamespace=true"
        ]
        "automated" = {
          "prune"    = true
          "selfHeal" = true
        }
      }
    }
  }
}
