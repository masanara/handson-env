output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

/*
output "cluster_certificate" {
  description = "EKS Cluster Certificate"
  value       = module.eks.cluster_certificate_authority_data
}
*/

output "controller-instance_ip" {
   value = aws_eip.eip.public_ip
}

output "aws_region" {
   value = var.aws_region
}
