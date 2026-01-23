output "vpc_id" {
  description = "The ID of the VPC"
  value       = alicloud_vpc.vpc.id
}

output "vpc_name" {
  description = "The name of the VPC"
  value       = alicloud_vpc.vpc.vpc_name
}

output "vswitch_ids" {
  description = "Map of VSwitch IDs (keyed by CIDR block)"
  value       = { for k, vswitch in alicloud_vswitch.vswitches : k => vswitch.id }
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = alicloud_security_group.sg.id
}

output "cluster_id" {
  description = "The ID of the ACK cluster"
  value       = alicloud_cs_managed_kubernetes.ack.id
}

output "cluster_name" {
  description = "The name of the ACK cluster"
  value       = alicloud_cs_managed_kubernetes.ack.name
}

output "cluster_vpc_id" {
  description = "The VPC ID of the cluster"
  value       = alicloud_cs_managed_kubernetes.ack.vpc_id
}

output "cluster_slb_internet" {
  description = "The public IP of load balancer"
  value       = alicloud_cs_managed_kubernetes.ack.slb_internet
}

output "cluster_slb_intranet" {
  description = "The ID of private load balancer where the current cluster master node is located"
  value       = alicloud_cs_managed_kubernetes.ack.slb_intranet
}

output "cluster_nat_gateway_id" {
  description = "The ID of nat gateway used to launch kubernetes cluster"
  value       = alicloud_cs_managed_kubernetes.ack.nat_gateway_id
}

output "cluster_connections" {
  description = "Map of kubernetes cluster connection information"
  value       = alicloud_cs_managed_kubernetes.ack.connections
}

output "node_pool_id" {
  description = "The ID of the node pool"
  value       = alicloud_cs_kubernetes_node_pool.node_pool.id
}

output "node_pool_scaling_group_id" {
  description = "The ID of the scaling group"
  value       = alicloud_cs_kubernetes_node_pool.node_pool.scaling_group_id
}

output "ros_stack_id" {
  description = "The ID of the ROS stack"
  value       = alicloud_ros_stack.deploy_k8s_resource.id
}

output "ros_stack_status" {
  description = "The status of the ROS stack"
  value       = alicloud_ros_stack.deploy_k8s_resource.status
}

output "created_ram_roles" {
  description = "The list of created RAM role names"
  value       = [for role in alicloud_ram_role.role : role.role_name]
}

output "ram_role_arns" {
  description = "The ARNs of the created RAM roles"
  value       = { for k, role in alicloud_ram_role.role : k => role.arn }
}