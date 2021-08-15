
output "kube_config" {
    value = module.k8s.kube_config
    sensitive = true
}



