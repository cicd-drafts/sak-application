# Meta AWS Application
This module creates the deployment on a Kubernetes cluster using Helm (as an option via ArgoCD) for the abstract application with IRSA integration.

## Usage:
``` hcl
module "app" {
  source = "github.com/cicd-drafts/sak-application"

  chart_version = "1.2.7"
  repository    = "https://some-chart-repo"
  name          = "some-app"
  chart         = "some-app"

  values = {
    rbac = {
      enabled = true
    }
  }
  argocd = {
    namespace = "argocd"
    project   = "default"
    path      = "from-repo-root"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| argocd | A set of values for enabling deployment through ArgoCD | `map(string)` | `{}` | no |
| chart | A Helm Chart name | `string` | n/a | yes |
| chart\_version | Version of Helm Chart | `string` | `"0.1.0"` | no |
| destination\_server | A destination server for ArgoCD application | `string` | `"https://kubernetes.default.svc"` | no |
| name | A name of the application | `string` | n/a | yes |
| namespace | A name of the existing namespace | `string` | `"default"` | no |
| namespace\_name | A name of namespace for creating | `string` | `"application"` | no |
| repository | A repository of Helm Chart | `string` | n/a | yes |
| values | A values for Helm Chart | `map` | `{}` | no |
