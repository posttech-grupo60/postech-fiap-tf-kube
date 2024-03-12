resource "kubernetes_deployment" "Node-API" {
  metadata {
    name = "node-api-tech-challenge"
    labels = {
      App = "node-api-tech-challenge"
    }
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        App = "node-api-tech-challenge"
      }
    }
    template {
      metadata {
        labels = {
          App = "node-api-tech-challenge"
        }
      }
      spec {
        container {
          image = "843787865322.dkr.ecr.us-east-1.amazonaws.com/fiap-tech-challenge-api:1.0.3"
          name  = "node-api-tech-challenge"

          port {
            container_port = 3000
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_horizontal_pod_autoscaler_v2" "HPA" {
  metadata {
    name = "hpa-node-api-tech-challenge-v2"
  }

  spec {
    max_replicas = 5
    min_replicas = 1

    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment.Node-API.metadata[0].name
    }

    metric {
      type = "External"
      external {
        metric {
          name = "latency"
          selector {
            match_labels = {
              name = "hpa-node-api-tech-challenge"
            }
          }
        }
        target {
          type  = "Value"
          value = "100"
        }
      }
    }
  }
}

resource "kubernetes_service" "LoadBalancer" {
  metadata {
    name = "load-balancer-node-api-tech-challenge"
  }
  spec {
    selector = {
      App = "node-api-tech-challenge"
    }
    port {
      port        = 3000
      target_port = 3000
    }
    type = "LoadBalancer"
  }
}

# Create a local variable for the load balancer name.
locals {
  lb_name = split("-", split(".", kubernetes_service.LoadBalancer.status.0.load_balancer.0.ingress.0.hostname).0).0
}

# Read information about the load balancer using the AWS provider.
data "aws_elb" "LoadBalancer" {
  name = local.lb_name
}

output "load_balancer_name" {
  value = local.lb_name
}

output "load_balancer_hostname" {
  value = kubernetes_service.LoadBalancer.status.0.load_balancer.0.ingress.0.hostname
}

output "load_balancer_info" {
  value = data.aws_elb.LoadBalancer
}