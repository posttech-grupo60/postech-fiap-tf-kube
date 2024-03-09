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
