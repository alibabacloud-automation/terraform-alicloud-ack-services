# 阿里云 ACK 弹性伸缩基础设施 Terraform 模块

terraform-alicloud-ack-services

======================================

[English](https://github.com/alibabacloud-automation/terraform-alicloud-ack-services/blob/main/README.md) | 简体中文

此 Terraform 模块在阿里云上创建高可用和弹性伸缩的 Kubernetes 基础设施，使用**容器服务 Kubernetes 版（ACK）**。本方案支持 Kubernetes **cluster-autoscaler** 和**水平 Pod 自动伸缩（HPA）**进行弹性伸缩，提升资源利用率，缩减资源成本。该模块自动创建 VPC、多可用区交换机、安全组、ACK 托管集群、节点池、ROS 栈和必需的 RAM 角色。包含预配置插件如 Terway 网络插件、CSI 存储插件、Logtail 和 Node Local DNS，实现生产就绪的部署。

## 用法

```hcl
provider "alicloud" {
  region = "cn-hangzhou"
}

module "ack_services" {
  source = "alibabacloud-automation/ack-services/alicloud"
  
  # VPC 配置
  vpc_name       = "my-ack-vpc"
  vpc_cidr_block = "10.0.0.0/8"
  
  # 交换机配置（多可用区实现高可用性）
  vswitches = [
    {
      zone_id      = "cn-hangzhou-i"
      cidr_block   = "10.0.0.0/24"
      vswitch_name = "ack-vswitch-zone-i"
    },
    {
      zone_id      = "cn-hangzhou-j"
      cidr_block   = "10.0.1.0/24"
      vswitch_name = "ack-vswitch-zone-j"
    }
  ]
  
  # 安全组规则
  security_group_rules = [
    {
      type        = "ingress"
      ip_protocol = "tcp"
      port_range  = "80/80"
      cidr_ip     = "0.0.0.0/0"
    },
    {
      type        = "ingress"
      ip_protocol = "tcp"
      port_range  = "443/443"
      cidr_ip     = "0.0.0.0/0"
    }
  ]
  
  # ACK 集群配置
  managed_kubernetes_cluster_name = "my-ack-cluster"
  cluster_spec                    = "ack.pro.small"
  service_cidr                    = "192.168.0.0/16"
  
  # 节点池配置（支持 cluster-autoscaler）
  node_pool_name       = "autoscaling-nodepool"
  instance_types       = ["ecs.g7.large"]
  system_disk_category = "cloud_essd"
  system_disk_size     = 120
  desired_size         = 3  # 初始节点数，可由 cluster-autoscaler 自动扩缩
  
  # 运行时配置
  runtime_name    = "containerd"
  runtime_version = "1.6.28"
  
  # ROS 栈配置（用于部署 K8s 资源）
  ros_stack_name = "ack-k8s-resources"
  template_url   = "https://ros-public-templates.oss-cn-hangzhou.aliyuncs.com/ros-templates/documents/solution/micro/build-microservices-on-ack-k8s-resource.tf.yaml"
}
```

## 示例

* [完整示例](https://github.com/alibabacloud-automation/terraform-alicloud-ack-services/tree/main/examples/complete)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [alicloud_cs_kubernetes_node_pool.node_pool](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/cs_kubernetes_node_pool) | resource |
| [alicloud_cs_managed_kubernetes.ack](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/cs_managed_kubernetes) | resource |
| [alicloud_ram_role.role](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ram_role) | resource |
| [alicloud_ram_role_policy_attachment.attach](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ram_role_policy_attachment) | resource |
| [alicloud_ros_stack.deploy_k8s_resource](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ros_stack) | resource |
| [alicloud_security_group.sg](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/security_group) | resource |
| [alicloud_security_group_rule.rules](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/security_group_rule) | resource |
| [alicloud_vpc.vpc](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vpc) | resource |
| [alicloud_vswitch.vswitches](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vswitch) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_addons"></a> [cluster\_addons](#input\_cluster\_addons) | The addons for the ACK cluster | <pre>list(object({<br>    name     = string<br>    config   = optional(string)<br>    version  = optional(string)<br>    disabled = optional(bool)<br>  }))</pre> | <pre>[<br>  {<br>    "name": "ack-node-local-dns"<br>  },<br>  {<br>    "config": "{\"IPVlan\":\"false\",\"NetworkPolicy\":\"false\",\"ENITrunking\":\"false\"}",<br>    "name": "terway-eniip"<br>  },<br>  {<br>    "name": "csi-plugin"<br>  },<br>  {<br>    "name": "csi-provisioner"<br>  },<br>  {<br>    "config": "{\"CnfsOssEnable\":\"false\",\"CnfsNasEnable\":\"false\"}",<br>    "name": "storage-operator"<br>  },<br>  {<br>    "disabled": true,<br>    "name": "nginx-ingress-controller"<br>  },<br>  {<br>    "config": "{\"IngressDashboardEnabled\":\"true\"}",<br>    "name": "logtail-ds"<br>  },<br>  {<br>    "config": "{\"albIngress\":{\"AddressType\":\"Internet\",\"CreateDefaultALBConfig\":true}}",<br>    "name": "alb-ingress-controller",<br>    "version": ""<br>  }<br>]</pre> | no |
| <a name="input_cluster_spec"></a> [cluster\_spec](#input\_cluster\_spec) | The specification of the cluster | `string` | `"ack.pro.small"` | no |
| <a name="input_delete_options"></a> [delete\_options](#input\_delete\_options) | The delete options for cluster resources | <pre>list(object({<br>    delete_mode   = string<br>    resource_type = string<br>  }))</pre> | <pre>[<br>  {<br>    "delete_mode": "delete",<br>    "resource_type": "ALB"<br>  },<br>  {<br>    "delete_mode": "delete",<br>    "resource_type": "SLB"<br>  },<br>  {<br>    "delete_mode": "delete",<br>    "resource_type": "SLS_Data"<br>  },<br>  {<br>    "delete_mode": "delete",<br>    "resource_type": "SLS_ControlPlane"<br>  },<br>  {<br>    "delete_mode": "delete",<br>    "resource_type": "PrivateZone"<br>  }<br>]</pre> | no |
| <a name="input_desired_size"></a> [desired\_size](#input\_desired\_size) | The desired number of nodes in the node pool | `number` | `3` | no |
| <a name="input_disable_rollback"></a> [disable\_rollback](#input\_disable\_rollback) | Whether to disable rollback for ROS stack | `bool` | `true` | no |
| <a name="input_existing_ram_role_names"></a> [existing\_ram\_role\_names](#input\_existing\_ram\_role\_names) | The list of existing RAM role names to avoid duplication | `list(string)` | `[]` | no |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | The instance types for the node pool | `list(string)` | <pre>[<br>  "ecs.g7.large"<br>]</pre> | no |
| <a name="input_managed_kubernetes_cluster_name"></a> [managed\_kubernetes\_cluster\_name](#input\_managed\_kubernetes\_cluster\_name) | The name of the ACK managed cluster | `string` | `"ack-services-cluster"` | no |
| <a name="input_new_nat_gateway"></a> [new\_nat\_gateway](#input\_new\_nat\_gateway) | Whether to create a new NAT gateway | `bool` | `true` | no |
| <a name="input_node_pool_name"></a> [node\_pool\_name](#input\_node\_pool\_name) | The name of the node pool | `string` | `"ack-services-nodepool"` | no |
| <a name="input_policy_type"></a> [policy\_type](#input\_policy\_type) | The type of policy to attach to RAM roles | `string` | `"System"` | no |
| <a name="input_ram_role_force"></a> [ram\_role\_force](#input\_ram\_role\_force) | Whether to force delete RAM roles | `bool` | `true` | no |
| <a name="input_ros_parameters"></a> [ros\_parameters](#input\_ros\_parameters) | The parameters for the ROS stack | <pre>list(object({<br>    parameter_key   = string<br>    parameter_value = string<br>  }))</pre> | <pre>[<br>  {<br>    "parameter_key": "cluster_id",<br>    "parameter_value": ""<br>  }<br>]</pre> | no |
| <a name="input_ros_stack_name"></a> [ros\_stack\_name](#input\_ros\_stack\_name) | The name of the ROS stack | `string` | `"ack-services-k8s-resource-stack"` | no |
| <a name="input_runtime_name"></a> [runtime\_name](#input\_runtime\_name) | The runtime name for containers | `string` | `"containerd"` | no |
| <a name="input_runtime_version"></a> [runtime\_version](#input\_runtime\_version) | The runtime version for containers | `string` | `"1.6.28"` | no |
| <a name="input_security_group_name"></a> [security\_group\_name](#input\_security\_group\_name) | The name of the security group | `string` | `"ack-services-sg"` | no |
| <a name="input_security_group_rules"></a> [security\_group\_rules](#input\_security\_group\_rules) | The parameters of security group rules. The attributes 'type', 'ip\_protocol', 'port\_range', 'cidr\_ip' are required. | <pre>list(object({<br>    type        = string<br>    ip_protocol = string<br>    port_range  = string<br>    cidr_ip     = string<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_ip": "0.0.0.0/0",<br>    "ip_protocol": "tcp",<br>    "port_range": "80/80",<br>    "type": "ingress"<br>  },<br>  {<br>    "cidr_ip": "0.0.0.0/0",<br>    "ip_protocol": "tcp",<br>    "port_range": "443/443",<br>    "type": "ingress"<br>  }<br>]</pre> | no |
| <a name="input_service_cidr"></a> [service\_cidr](#input\_service\_cidr) | The service CIDR block for the cluster | `string` | `"192.168.0.0/16"` | no |
| <a name="input_slb_internet_enabled"></a> [slb\_internet\_enabled](#input\_slb\_internet\_enabled) | Whether to enable internet SLB | `bool` | `true` | no |
| <a name="input_system_disk_category"></a> [system\_disk\_category](#input\_system\_disk\_category) | The category of system disk | `string` | `"cloud_essd"` | no |
| <a name="input_system_disk_size"></a> [system\_disk\_size](#input\_system\_disk\_size) | The size of system disk | `number` | `120` | no |
| <a name="input_template_url"></a> [template\_url](#input\_template\_url) | The URL of the ROS template | `string` | `"https://ros-public-templates.oss-cn-hangzhou.aliyuncs.com/ros-templates/documents/solution/micro/build-microservices-on-ack-k8s-resource.tf.yaml"` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | The CIDR block for the VPC | `string` | `"10.0.0.0/8"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | The name of the VPC | `string` | `"ack-services-vpc"` | no |
| <a name="input_vswitches"></a> [vswitches](#input\_vswitches) | The parameters of vswitches. The attributes 'zone\_id', 'cidr\_block' are required. | <pre>list(object({<br>    zone_id      = string<br>    cidr_block   = string<br>    vswitch_name = optional(string, null)<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_block": "10.0.0.0/24",<br>    "vswitch_name": "ack-services-vswitch1",<br>    "zone_id": "cn-hangzhou-i"<br>  },<br>  {<br>    "cidr_block": "10.0.1.0/24",<br>    "vswitch_name": "ack-services-vswitch2",<br>    "zone_id": "cn-hangzhou-j"<br>  }<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_connections"></a> [cluster\_connections](#output\_cluster\_connections) | Map of kubernetes cluster connection information |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The ID of the ACK cluster |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the ACK cluster |
| <a name="output_cluster_nat_gateway_id"></a> [cluster\_nat\_gateway\_id](#output\_cluster\_nat\_gateway\_id) | The ID of nat gateway used to launch kubernetes cluster |
| <a name="output_cluster_slb_internet"></a> [cluster\_slb\_internet](#output\_cluster\_slb\_internet) | The public IP of load balancer |
| <a name="output_cluster_slb_intranet"></a> [cluster\_slb\_intranet](#output\_cluster\_slb\_intranet) | The ID of private load balancer where the current cluster master node is located |
| <a name="output_cluster_vpc_id"></a> [cluster\_vpc\_id](#output\_cluster\_vpc\_id) | The VPC ID of the cluster |
| <a name="output_created_ram_roles"></a> [created\_ram\_roles](#output\_created\_ram\_roles) | The list of created RAM role names |
| <a name="output_node_pool_id"></a> [node\_pool\_id](#output\_node\_pool\_id) | The ID of the node pool |
| <a name="output_node_pool_scaling_group_id"></a> [node\_pool\_scaling\_group\_id](#output\_node\_pool\_scaling\_group\_id) | The ID of the scaling group |
| <a name="output_ram_role_arns"></a> [ram\_role\_arns](#output\_ram\_role\_arns) | The ARNs of the created RAM roles |
| <a name="output_ros_stack_id"></a> [ros\_stack\_id](#output\_ros\_stack\_id) | The ID of the ROS stack |
| <a name="output_ros_stack_status"></a> [ros\_stack\_status](#output\_ros\_stack\_status) | The status of the ROS stack |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the security group |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vpc_name"></a> [vpc\_name](#output\_vpc\_name) | The name of the VPC |
| <a name="output_vswitch_ids"></a> [vswitch\_ids](#output\_vswitch\_ids) | Map of VSwitch IDs (keyed by CIDR block) |
<!-- END_TF_DOCS -->

## 提交问题

如果您在使用此模块时遇到任何问题，请提交
[provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) 并告知我们。

**注意**：不建议在此仓库上提交问题。

## 作者

由阿里云 Terraform 团队创建和维护(terraform@alibabacloud.com)。

## 许可证

MIT 许可证。详细信息请参见 LICENSE。

## 参考

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)
* [ACK 文档](https://www.alibabacloud.com/help/zh/container-service-for-kubernetes)
