output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.ack_services.vpc_id
}

output "cluster_id" {
  description = "The ID of the ACK cluster"
  value       = module.ack_services.cluster_id
}

output "cluster_name" {
  description = "The name of the ACK cluster"
  value       = module.ack_services.cluster_name
}

output "cluster_connections" {
  description = "Map of kubernetes cluster connection information"
  value       = module.ack_services.cluster_connections
  sensitive   = true
}

output "node_pool_id" {
  description = "The ID of the node pool"
  value       = module.ack_services.node_pool_id
}

output "ros_stack_id" {
  description = "The ID of the ROS stack"
  value       = module.ack_services.ros_stack_id
}

output "created_ram_roles" {
  description = "The list of created RAM role names"
  value       = module.ack_services.created_ram_roles
}