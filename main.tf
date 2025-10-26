resource "helm_release" "gha_runner_scale_set_controller" {
  name             = var.release_name
  chart            = var.chart
  namespace        = var.namespace
  create_namespace = var.create_namespace
  atomic           = var.atomic
  timeout          = var.timeout

  version = var.chart_version 

  values = length(keys(var.values)) > 0 ? [yamlencode(var.values)] : []
}
