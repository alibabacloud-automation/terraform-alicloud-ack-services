locals {
  # Define all required RAM roles and their policies
  cs_roles = [
    {
      name            = "AliyunCSManagedLogRole"
      policy_document = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":[\"cs.aliyuncs.com\"]}}],\"Version\":\"1\"}"
      description     = "The log component of the cluster uses this role to access resources in other cloud services."
      policy_name     = "AliyunCSManagedLogRolePolicy"
    },
    {
      name            = "AliyunCSManagedCmsRole"
      policy_document = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":[\"cs.aliyuncs.com\"]}}],\"Version\":\"1\"}"
      description     = "The CMS component of the cluster uses this role to access resources in other cloud services."
      policy_name     = "AliyunCSManagedCmsRolePolicy"
    },
    {
      name            = "AliyunCSManagedCsiRole"
      policy_document = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":[\"cs.aliyuncs.com\"]}}],\"Version\":\"1\"}"
      description     = "The storage component of the cluster uses this role to access resources in other cloud services."
      policy_name     = "AliyunCSManagedCsiRolePolicy"
    },
    {
      name            = "AliyunCSManagedCsiPluginRole"
      policy_document = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":[\"cs.aliyuncs.com\"]}}],\"Version\":\"1\"}"
      description     = "The storage component of the cluster uses this role to access resources in other cloud services."
      policy_name     = "AliyunCSManagedCsiPluginRolePolicy"
    },
    {
      name            = "AliyunCSManagedCsiProvisionerRole"
      policy_document = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":[\"cs.aliyuncs.com\"]}}],\"Version\":\"1\"}"
      description     = "The storage component of the cluster uses this role to access resources in other cloud services."
      policy_name     = "AliyunCSManagedCsiProvisionerRolePolicy"
    },
    {
      name            = "AliyunCSManagedVKRole"
      policy_document = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":[\"cs.aliyuncs.com\"]}}],\"Version\":\"1\"}"
      description     = "The VK component of ACK Serverless cluster uses this role to access resources in other cloud services."
      policy_name     = "AliyunCSManagedVKRolePolicy"
    },
    {
      name            = "AliyunCSServerlessKubernetesRole"
      policy_document = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":[\"cs.aliyuncs.com\"]}}],\"Version\":\"1\"}"
      description     = "The cluster uses this role by default to access resources in other cloud services."
      policy_name     = "AliyunCSServerlessKubernetesRolePolicy"
    },
    {
      name            = "AliyunCSKubernetesAuditRole"
      policy_document = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":[\"cs.aliyuncs.com\"]}}],\"Version\":\"1\"}"
      description     = "The cluster audit function uses this role to access resources in other cloud services."
      policy_name     = "AliyunCSKubernetesAuditRolePolicy"
    },
    {
      name            = "AliyunCSManagedNetworkRole"
      policy_document = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":[\"cs.aliyuncs.com\"]}}],\"Version\":\"1\"}"
      description     = "The network component of the cluster uses this role to access resources in other cloud services."
      policy_name     = "AliyunCSManagedNetworkRolePolicy"
    },
    {
      name            = "AliyunCSDefaultRole"
      policy_document = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":[\"cs.aliyuncs.com\"]}}],\"Version\":\"1\"}"
      description     = "The cluster uses this role by default when operating to access resources in other cloud services."
      policy_name     = "AliyunCSDefaultRolePolicy"
    },
    {
      name            = "AliyunCSManagedKubernetesRole"
      policy_document = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":[\"cs.aliyuncs.com\"]}}],\"Version\":\"1\"}"
      description     = "The cluster uses this role by default to access resources in other cloud services."
      policy_name     = "AliyunCSManagedKubernetesRolePolicy"
    },
    {
      name            = "AliyunCSManagedArmsRole"
      policy_document = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":[\"cs.aliyuncs.com\"]}}],\"Version\":\"1\"}"
      description     = "The cluster Arms plugin uses this role to access resources in other cloud services."
      policy_name     = "AliyunCSManagedArmsRolePolicy"
    },
    {
      name            = "AliyunCISDefaultRole"
      policy_document = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":[\"cs.aliyuncs.com\"]}}],\"Version\":\"1\"}"
      description     = "Container Service (CS) intelligent operations uses this role to access resources in other cloud services."
      policy_name     = "AliyunCISDefaultRolePolicy"
    },
    {
      name            = "AliyunOOSLifecycleHook4CSRole"
      policy_document = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":[\"oos.aliyuncs.com\"]}}],\"Version\":\"1\"}"
      description     = "Cluster scaling node pool depends on OOS service, OOS uses this role to access resources in other cloud services."
      policy_name     = "AliyunOOSLifecycleHook4CSRolePolicy"
    },
    {
      name            = "AliyunCSManagedAutoScalerRole"
      policy_document = "{\"Statement\":[{\"Action\":\"sts:AssumeRole\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":[\"cs.aliyuncs.com\"]}}],\"Version\":\"1\"}"
      description     = "The elastic scaling component of the cluster uses this role to access resources in other cloud services."
      policy_name     = "AliyunCSManagedAutoScalerRolePolicy"
    }
  ]

  # Extract all required RAM role names
  all_role_names = [for role in local.cs_roles : role.name]

  # Extract names of existing RAM roles
  created_role_names = var.ram_role.existing_role_names

  # Calculate complement: find roles that haven't been created yet
  complement_names = setsubtract(local.all_role_names, local.created_role_names)

  # Roles to be created
  complement_roles = [for role in local.cs_roles : role if contains(local.complement_names, role.name)]

  # ROS Stack parameters with cluster_id default value
  ros_stack_parameters = var.ros_stack.parameters != null ? var.ros_stack.parameters : [
    {
      parameter_key   = "cluster_id"
      parameter_value = alicloud_cs_managed_kubernetes.ack.id
    }
  ]
}

# Create VPC
resource "alicloud_vpc" "vpc" {
  cidr_block = var.vpc.cidr_block
  vpc_name   = var.vpc.vpc_name
}

# Create VSwitches
resource "alicloud_vswitch" "vswitches" {
  for_each     = { for vswitch in var.vswitches : vswitch.cidr_block => vswitch }
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = each.value.cidr_block
  zone_id      = each.value.zone_id
  vswitch_name = each.value.vswitch_name
}

# Create Security Group
resource "alicloud_security_group" "sg" {
  vpc_id              = alicloud_vpc.vpc.id
  security_group_name = var.security_group.name
}

# Create Security Group Rules
resource "alicloud_security_group_rule" "rules" {
  for_each          = { for rule in var.security_group.rules : "${rule.type}-${rule.ip_protocol}-${rule.port_range}-${rule.cidr_ip}" => rule }
  security_group_id = alicloud_security_group.sg.id
  type              = each.value.type
  ip_protocol       = each.value.ip_protocol
  port_range        = each.value.port_range
  cidr_ip           = each.value.cidr_ip
}

# Create ACK Cluster
resource "alicloud_cs_managed_kubernetes" "ack" {
  depends_on           = [alicloud_ram_role_policy_attachment.attach]
  name                 = var.ack_cluster.name
  cluster_spec         = var.ack_cluster.cluster_spec
  vswitch_ids          = [for vswitch in alicloud_vswitch.vswitches : vswitch.id]
  pod_vswitch_ids      = [for vswitch in alicloud_vswitch.vswitches : vswitch.id]
  service_cidr         = var.ack_cluster.service_cidr
  new_nat_gateway      = var.ack_cluster.new_nat_gateway
  slb_internet_enabled = var.ack_cluster.slb_internet_enabled
  security_group_id    = alicloud_security_group.sg.id

  dynamic "addons" {
    for_each = var.ack_cluster.addons
    content {
      name     = addons.value.name
      config   = lookup(addons.value, "config", "")
      version  = lookup(addons.value, "version", "")
      disabled = addons.value.disabled
    }
  }

  dynamic "delete_options" {
    for_each = var.ack_cluster.delete_options
    content {
      delete_mode   = delete_options.value.delete_mode
      resource_type = delete_options.value.resource_type
    }
  }
}

# Create Node Pool
resource "alicloud_cs_kubernetes_node_pool" "node_pool" {
  node_pool_name       = var.node_pool.name
  cluster_id           = alicloud_cs_managed_kubernetes.ack.id
  vswitch_ids          = [for vswitch in alicloud_vswitch.vswitches : vswitch.id]
  instance_types       = var.node_pool.instance_types
  system_disk_category = var.node_pool.system_disk_category
  system_disk_size     = var.node_pool.system_disk_size
  desired_size         = var.node_pool.desired_size
  runtime_name         = var.node_pool.runtime_name
  runtime_version      = var.node_pool.runtime_version
}

# Create ROS Stack for K8s Resources
resource "alicloud_ros_stack" "deploy_k8s_resource" {
  stack_name   = var.ros_stack.name
  template_url = var.ros_stack.template_url

  dynamic "parameters" {
    for_each = local.ros_stack_parameters
    content {
      parameter_key   = parameters.value.parameter_key
      parameter_value = parameters.value.parameter_value
    }
  }

  disable_rollback = var.ros_stack.disable_rollback
  depends_on       = [alicloud_cs_kubernetes_node_pool.node_pool]
}

# Create RAM Roles
resource "alicloud_ram_role" "role" {
  for_each                    = { for r in local.complement_roles : r.name => r }
  role_name                   = each.value.name
  assume_role_policy_document = each.value.policy_document
  description                 = each.value.description
  force                       = var.ram_role.force
}

# Attach System Policies to RAM Roles
resource "alicloud_ram_role_policy_attachment" "attach" {
  for_each    = alicloud_ram_role.role
  policy_name = [for role in local.cs_roles : role.policy_name if role.name == each.value.role_name][0]
  policy_type = var.ram_role.policy_type
  role_name   = each.value.role_name
}