variable "values" {
  type        = map
  default     = {}
  description = "A values for Helm Chart in YAML format"
}

variable "namespace" {
  type        = string
  default     = "default"
  description = "A name of the existing namespace"
}

variable "namespace_name" {
  type        = string
  default     = "application"
  description = "A name of namespace for creating"
}

variable "chart_version" {
  default     = "0.1.0"
  description = "Version of Helm Chart"
}

variable "force_argocd" {
  default = 0
}

variable "argocd" {
  type        = map(string)
  description = "A set of values for enabling deployment through ArgoCD"
  default     = {}
}

variable "repository" {
  type        = string
  description = "A repository of Helm Chart"
}

variable "chart" {
  type        = string
  description = "A Helm Chart name"
}

variable "name" {
  type        = string
  description = "A name of the application"
}

variable "service_account_name" {
  type        = string
  default     = ""
  description = "A name of the service account, in case of using custom SA name not matching with application name"
}

variable "destination_server" {
  type        = string
  default     = "https://kubernetes.default.svc"
  description = "A destination server for ArgoCD application"
}

variable "project" {
  type        = string
  default     = ""
  description = "A custom ArgoCD project for application, if not specified a project of ArgoCD itself be used"
}

variable "argocd_custom_app_settings" {
  type        = any
  default     = {}
  description = "A custom ArgoCD application settings, for example: use folder with Helm chart instead of chart repository"
}
