module "prod" {
  source = "../../infra"
  
  cluster_name = "TechChallengeCluster"
}

output "LBName" {
  value = module.prod.load_balancer_name
}

output "LBHostname" {
  value = module.prod.load_balancer_hostname
}

output "LBInfo" {
  value = module.prod.load_balancer_info
}