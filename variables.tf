variable "release_name" {
  description = "Name of the Helm release"
  type        = string
  default     = "arc"
}

variable "namespace" {
  description = "Namespace to install the chart into"
  type        = string
  default     = "arc-systems"
}

variable "chart" {
  description = "Helm chart name"
  type        = string
  default = "oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller"
}

variable "repository" {
  description = "Helm chart repository URL"
  type        = string
  default     = "actions-runner-controller"
}

variable "chart_version" {
  description = "Chart version to install (leave empty for latest)"
  type        = string
  default     = "0.13.0"
}

variable "create_namespace" {
  description = "Whether Helm should create the namespace"
  type        = bool
  default     = true
}

variable "atomic" {
  description = "Enable Helm atomic install/upgrade"
  type        = bool
  default     = true
}

variable "timeout" {
  description = "Helm operation timeout in seconds"
  type        = number
  default     = 300
}

# Controller configuration
variable "controller_labels" {
  description = "Labels to add to controller resources"
  type        = map(string)
  default     = {}
}

variable "replica_count" {
  description = "Number of controller replicas"
  type        = number
  default     = 1
}

variable "webhook_port" {
  description = "Port for the webhook server"
  type        = number
  default     = 9443
}

variable "sync_period" {
  description = "Period for syncing runner resources"
  type        = string
  default     = "1m"
}

variable "default_scale_down_delay" {
  description = "Default delay before scaling down runners"
  type        = string
  default     = "10m"
}

variable "enable_leader_election" {
  description = "Enable leader election for controller"
  type        = bool
  default     = true
}

variable "docker_registry_mirror" {
  description = "URL for docker registry mirror"
  type        = string
  default     = ""
}

# Image configuration
variable "controller_image" {
  description = "Controller image configuration"
  type = object({
    repository                    = string
    actionsRunnerRepositoryAndTag = string
    dindSidecarRepositoryAndTag   = string
    pullPolicy                    = string
    actionsRunnerImagePullSecrets = list(string)
  })
  default = {
    repository                    = "summerwind/actions-runner-controller"
    actionsRunnerRepositoryAndTag = "summerwind/actions-runner:latest"
    dindSidecarRepositoryAndTag   = "docker:dind"
    pullPolicy                    = "IfNotPresent"
    actionsRunnerImagePullSecrets = []
  }
}

variable "image_pull_secrets" {
  description = "List of image pull secrets"
  type        = list(string)
  default     = []
}

variable "name_override" {
  description = "Override for resource naming"
  type        = string
  default     = ""
}

variable "fullname_override" {
  description = "Override for full resource naming"
  type        = string
  default     = ""
}

# Runner configuration
variable "runner_config" {
  description = "Runner specific configuration"
  type = object({
    statusUpdateHook = object({
      enabled = bool
    })
  })
  default = {
    statusUpdateHook = {
      enabled = false
    }
  }
}

# RBAC configuration
variable "rbac_config" {
  description = "RBAC configuration settings"
  type        = map(any)
  default     = {}
}

# Service Account configuration
variable "service_account_config" {
  description = "Service account configuration"
  type = object({
    create      = bool
    annotations = map(string)
    name        = string
  })
  default = {
    create      = true
    annotations = {}
    name        = ""
  }
}

# Pod configuration
variable "pod_annotations" {
  description = "Annotations for controller pods"
  type        = map(string)
  default     = {}
}

variable "pod_labels" {
  description = "Labels for controller pods"
  type        = map(string)
  default     = {}
}

variable "pod_security_context" {
  description = "Pod security context"
  type        = map(any)
  default     = {}
}

variable "security_context" {
  description = "Container security context"
  type        = map(any)
  default     = {}
}

# Service configuration
variable "service_config" {
  description = "Service configuration for the controller"
  type = object({
    type        = string
    port        = number
    annotations = map(string)
  })
  default = {
    type        = "ClusterIP"
    port        = 443
    annotations = {}
  }
}

# Metrics configuration
variable "metrics_config" {
  description = "Metrics configuration"
  type = object({
    serviceAnnotations    = map(string)
    serviceMonitor       = object({
      enable    = bool
      namespace = string
      timeout   = string
      interval  = string
    })
    serviceMonitorLabels = map(string)
    port                = number
    proxy               = object({
      enabled = bool
      image   = object({
        repository = string
        tag        = string
      })
    })
  })
  default = {
    serviceAnnotations = {}
    serviceMonitor    = {
      enable    = false
      namespace = ""
      timeout   = "30s"
      interval  = "1m"
    }
    serviceMonitorLabels = {}
    port                = 8443
    proxy = {
      enabled = true
      image = {
        repository = "quay.io/brancz/kube-rbac-proxy"
        tag        = "v0.13.1"
      }
    }
  }
}

# Resource management
variable "resources_config" {
  description = "Resource requests and limits"
  type        = map(any)
  default     = {}
}

variable "node_selector" {
  description = "Node selector for controller pods"
  type        = map(string)
  default     = {}
}

variable "tolerations" {
  description = "Tolerations for controller pods"
  type        = list(any)
  default     = []
}

variable "affinity" {
  description = "Affinity rules for controller pods"
  type        = map(any)
  default     = {}
}

# Pod disruption budget
variable "pdb_config" {
  description = "Pod disruption budget configuration"
  type = object({
    enabled        = bool
    minAvailable   = optional(number)
    maxUnavailable = optional(number)
  })
  default = {
    enabled = false
  }
}

variable "priority_class_name" {
  description = "Priority class name for controller pods"
  type        = string
  default     = ""
}

# Authentication configuration
variable "auth_secret_config" {
  description = "Authentication secret configuration"
  type = object({
    enabled                   = bool
    create                   = bool
    name                     = string
    annotations              = map(string)
    github_app_id            = optional(string)
    github_app_installation_id = optional(string)
    github_app_private_key    = optional(string)
    github_token             = optional(string)
    github_basicauth_username = optional(string)
    github_basicauth_password = optional(string)
  })
  default = {
    enabled     = true
    create      = false
    name        = "controller-manager"
    annotations = {}
  }
}

# Scope configuration
variable "scope_config" {
  description = "Controller scope configuration"
  type = object({
    singleNamespace = bool
    watchNamespace  = string
  })
  default = {
    singleNamespace = false
    watchNamespace  = ""
  }
}

variable "cert_manager_enabled" {
  description = "Enable cert-manager integration"
  type        = bool
  default     = true
}

variable "admission_webhooks_config" {
  description = "Admission webhooks configuration"
  type        = map(any)
  default     = {}
}

variable "log_format" {
  description = "Log format for controller"
  type        = string
  default     = "text"
}

# GitHub webhook server configuration
variable "github_webhook_config" {
  description = "GitHub webhook server configuration"
  type = object({
    enabled                   = bool
    replicaCount             = number
    useRunnerGroupsVisibility = bool
    logFormat                = string
    secret = object({
      enabled                    = bool
      create                     = bool
      name                       = string
      github_webhook_secret_token = optional(string)
      github_app_id              = optional(string)
      github_app_installation_id  = optional(string)
      github_app_private_key     = optional(string)
      github_token               = optional(string)
    })
    imagePullSecrets         = list(string)
    nameOverride             = string
    fullnameOverride         = string
    serviceAccount = object({
      create      = bool
      annotations = map(string)
      name        = string
    })
    podAnnotations          = map(string)
    podLabels              = map(string)
    podSecurityContext     = map(any)
    securityContext        = map(any)
    resources              = map(any)
    nodeSelector           = map(string)
    tolerations            = list(any)
    affinity              = map(any)
    priorityClassName      = string
    service = object({
      type        = string
      annotations = map(string)
      ports = list(object({
        port        = number
        targetPort  = string
        protocol    = string
        name        = string
      }))
      loadBalancerSourceRanges = list(string)
    })
    ingress = object({
      enabled           = bool
      ingressClassName = string
      annotations      = map(string)
      hosts = list(object({
        host       = string
        paths      = list(any)
        extraPaths = list(any)
      }))
      tls = list(any)
    })
    podDisruptionBudget = object({
      enabled        = bool
      minAvailable   = optional(number)
      maxUnavailable = optional(number)
    })
    terminationGracePeriodSeconds = number
    lifecycle                     = map(any)
  })
  default = {
    enabled                   = false
    replicaCount             = 1
    useRunnerGroupsVisibility = false
    logFormat                = "text"
    secret = {
      enabled = false
      create  = false
      name    = "github-webhook-server"
    }
    imagePullSecrets = []
    nameOverride     = ""
    fullnameOverride = ""
    serviceAccount = {
      create      = true
      annotations = {}
      name        = ""
    }
    podAnnotations     = {}
    podLabels         = {}
    podSecurityContext = {}
    securityContext    = {}
    resources         = {}
    nodeSelector      = {}
    tolerations       = []
    affinity         = {}
    priorityClassName = ""
    service = {
      type        = "ClusterIP"
      annotations = {}
      ports = [{
        port        = 80
        targetPort  = "http"
        protocol    = "TCP"
        name        = "http"
      }]
      loadBalancerSourceRanges = []
    }
    ingress = {
      enabled           = false
      ingressClassName = ""
      annotations      = {}
      hosts = [{
        host       = "chart-example.local"
        paths      = []
        extraPaths = []
      }]
      tls = []
    }
    podDisruptionBudget = {
      enabled = false
    }
    terminationGracePeriodSeconds = 10
    lifecycle                     = {}
  }
}

# Metrics server configuration
variable "metrics_server_config" {
  description = "Actions metrics server configuration"
  type = object({
    enabled     = bool
    replicaCount = number
    logFormat   = string
    secret = object({
      enabled                    = bool
      create                     = bool
      name                       = string
      github_webhook_secret_token = optional(string)
      github_app_id              = optional(string)
      github_app_installation_id  = optional(string)
      github_app_private_key     = optional(string)
      github_token               = optional(string)
    })
    imagePullSecrets = list(string)
    nameOverride     = string
    fullnameOverride = string
    serviceAccount = object({
      create      = bool
      annotations = map(string)
      name        = string
    })
    podAnnotations     = map(string)
    podLabels         = map(string)
    podSecurityContext = map(any)
    securityContext    = map(any)
    resources         = map(any)
    nodeSelector      = map(string)
    tolerations       = list(any)
    affinity         = map(any)
    priorityClassName = string
    service = object({
      type        = string
      annotations = map(string)
      ports = list(object({
        port        = number
        targetPort  = string
        protocol    = string
        name        = string
      }))
      loadBalancerSourceRanges = list(string)
    })
    ingress = object({
      enabled           = bool
      ingressClassName = string
      annotations      = map(string)
      hosts = list(object({
        host       = string
        paths      = list(any)
        extraPaths = list(any)
      }))
      tls = list(any)
    })
    terminationGracePeriodSeconds = number
    lifecycle                     = map(any)
  })
  default = {
    enabled     = false
    replicaCount = 1
    logFormat   = "text"
    secret = {
      enabled = false
      create  = false
      name    = "actions-metrics-server"
    }
    imagePullSecrets = []
    nameOverride     = ""
    fullnameOverride = ""
    serviceAccount = {
      create      = true
      annotations = {}
      name        = ""
    }
    podAnnotations     = {}
    podLabels         = {}
    podSecurityContext = {}
    securityContext    = {}
    resources         = {}
    nodeSelector      = {}
    tolerations       = []
    affinity         = {}
    priorityClassName = ""
    service = {
      type        = "ClusterIP"
      annotations = {}
      ports = [{
        port        = 80
        targetPort  = "http"
        protocol    = "TCP"
        name        = "http"
      }]
      loadBalancerSourceRanges = []
    }
    ingress = {
      enabled           = false
      ingressClassName = ""
      annotations      = {}
      hosts = [{
        host       = "chart-example.local"
        paths      = []
        extraPaths = []
      }]
      tls = []
    }
    terminationGracePeriodSeconds = 10
    lifecycle                     = {}
  }
}

variable "namespace_override" {
  description = "Override the namespace for all resources"
  type        = string
  default     = ""
}

variable "values" {
  description = "Values for the actions-runner-controller Helm chart"
  type = object({
    labels                  = map(string)
    replicaCount           = number
    webhookPort            = number
    syncPeriod             = string
    defaultScaleDownDelay  = string
    enableLeaderElection   = bool
    dockerRegistryMirror   = string
    
    image = object({
      repository                     = string
      actionsRunnerRepositoryAndTag  = string
      dindSidecarRepositoryAndTag    = string
      pullPolicy                     = string
      actionsRunnerImagePullSecrets  = list(string)
    })

    imagePullSecrets = list(string)
    nameOverride     = string
    fullnameOverride = string

    runner = object({
      statusUpdateHook = object({
        enabled = bool
      })
    })

    rbac = map(any)

    serviceAccount = object({
      create      = bool
      annotations = map(string)
      name        = string
    })

    podAnnotations     = map(string)
    podLabels         = map(string)
    podSecurityContext = map(any)
    securityContext    = map(any)

    service = object({
      type        = string
      port        = number
      annotations = map(string)
    })

    metrics = object({
      serviceAnnotations = map(string)
      serviceMonitor = object({
        enable    = bool
        namespace = string
        timeout   = string
        interval  = string
      })
      serviceMonitorLabels = map(string)
      port                = number
      proxy = object({
        enabled = bool
        image = object({
          repository = string
          tag        = string
        })
      })
    })

    resources    = map(any)
    nodeSelector = map(string)
    tolerations  = list(any)
    affinity     = map(any)

    podDisruptionBudget = object({
      enabled = bool
      # Only one of minAvailable or maxUnavailable can be set
      minAvailable    = optional(number)
      maxUnavailable  = optional(number)
    })

    priorityClassName = string
    
    authSecret = object({
      enabled     = bool
      create      = bool
      name        = string
      annotations = map(string)
      # GitHub Apps Configuration
      github_app_id              = optional(string)
      github_app_installation_id = optional(string)
      github_app_private_key     = optional(string)
      # GitHub PAT Configuration
      github_token               = optional(string)
      # Basic auth for github API proxy
      github_basicauth_username  = optional(string)
      github_basicauth_password  = optional(string)
    })

    scope = object({
      singleNamespace = bool
      watchNamespace  = string
    })

    certManagerEnabled = bool
    admissionWebHooks = map(any)
    logFormat         = string

    githubWebhookServer = object({
      enabled                   = bool
      replicaCount             = number
      useRunnerGroupsVisibility = bool
      logFormat                = string
      
      secret = object({
        enabled     = bool
        create      = bool
        name        = string
        github_webhook_secret_token = optional(string)
        github_app_id               = optional(string)
        github_app_installation_id  = optional(string)
        github_app_private_key      = optional(string)
        github_token                = optional(string)
      })

      imagePullSecrets = list(string)
      nameOverride     = string
      fullnameOverride = string

      serviceAccount = object({
        create      = bool
        annotations = map(string)
        name        = string
      })

      podAnnotations     = map(string)
      podLabels         = map(string)
      podSecurityContext = map(any)
      securityContext    = map(any)
      resources         = map(any)
      nodeSelector      = map(string)
      tolerations       = list(any)
      affinity         = map(any)
      priorityClassName = string

      service = object({
        type        = string
        annotations = map(string)
        ports = list(object({
          port        = number
          targetPort  = string
          protocol    = string
          name        = string
        }))
        loadBalancerSourceRanges = list(string)
      })

      ingress = object({
        enabled           = bool
        ingressClassName = string
        annotations      = map(string)
        hosts = list(object({
          host       = string
          paths      = list(any)
          extraPaths = list(any)
        }))
        tls = list(any)
      })

      podDisruptionBudget = object({
        enabled        = bool
        minAvailable   = optional(number)
        maxUnavailable = optional(number)
      })

      terminationGracePeriodSeconds = number
      lifecycle                     = map(any)
    })

    actionsMetrics = object({
      serviceAnnotations = map(string)
      serviceMonitor = object({
        enable    = bool
        namespace = string
        timeout   = string
        interval  = string
      })
      serviceMonitorLabels = map(string)
      port                = number
      proxy = object({
        enabled = bool
        image = object({
          repository = string
          tag        = string
        })
      })
    })

    actionsMetricsServer = object({
      enabled     = bool
      replicaCount = number
      logFormat   = string

      secret = object({
        enabled     = bool
        create      = bool
        name        = string
        github_webhook_secret_token = optional(string)
        github_app_id               = optional(string)
        github_app_installation_id  = optional(string)
        github_app_private_key      = optional(string)
        github_token                = optional(string)
      })

      imagePullSecrets = list(string)
      nameOverride     = string
      fullnameOverride = string

      serviceAccount = object({
        create      = bool
        annotations = map(string)
        name        = string
      })

      podAnnotations     = map(string)
      podLabels         = map(string)
      podSecurityContext = map(any)
      securityContext    = map(any)
      resources         = map(any)
      nodeSelector      = map(string)
      tolerations       = list(any)
      affinity         = map(any)
      priorityClassName = string

      service = object({
        type        = string
        annotations = map(string)
        ports = list(object({
          port        = number
          targetPort  = string
          protocol    = string
          name        = string
        }))
        loadBalancerSourceRanges = list(string)
      })

      ingress = object({
        enabled           = bool
        ingressClassName = string
        annotations      = map(string)
        hosts = list(object({
          host       = string
          paths      = list(any)
          extraPaths = list(any)
        }))
        tls = list(any)
      })

      terminationGracePeriodSeconds = number
      lifecycle                     = map(any)
    })

    namespaceOverride = string
  })

  default = {
    labels                  = var.controller_labels
    replicaCount           = var.replica_count
    webhookPort            = var.webhook_port
    syncPeriod             = var.sync_period
    defaultScaleDownDelay  = var.default_scale_down_delay
    enableLeaderElection   = var.enable_leader_election
    dockerRegistryMirror   = var.docker_registry_mirror

    image             = var.controller_image
    imagePullSecrets = var.image_pull_secrets
    nameOverride     = var.name_override
    fullnameOverride = var.fullname_override

    runner            = var.runner_config
    rbac              = var.rbac_config
    serviceAccount    = var.service_account_config
    podAnnotations    = var.pod_annotations
    podLabels        = var.pod_labels
    podSecurityContext = var.pod_security_context
    securityContext   = var.security_context

    service            = var.service_config
    metrics            = var.metrics_config
    resources         = var.resources_config
    nodeSelector      = var.node_selector
    tolerations       = var.tolerations
    affinity          = var.affinity
    podDisruptionBudget = var.pdb_config
    priorityClassName = var.priority_class_name
    authSecret        = var.auth_secret_config
    scope             = var.scope_config
    certManagerEnabled = var.cert_manager_enabled
    admissionWebHooks = var.admission_webhooks_config
    logFormat         = var.log_format

    githubWebhookServer = var.github_webhook_config

    actionsMetrics = var.metrics_config
    actionsMetricsServer = var.metrics_server_config
    namespaceOverride = var.namespace_override
  }
}
