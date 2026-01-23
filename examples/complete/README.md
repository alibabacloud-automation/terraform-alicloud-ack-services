# Complete Example

This example demonstrates how to create a complete ACK services infrastructure using the terraform-alicloud-ack-services module.

## Features

This example creates:

- A VPC with two VSwitch subnets in different availability zones
- Security groups with HTTP/HTTPS access rules
- An ACK managed cluster with professional specifications
- A node pool with 3 worker nodes
- ROS stack deployment for Kubernetes resources
- Necessary RAM roles for cluster operations

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ack_services"></a> [ack\_services](#module\_ack\_services) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [random_integer.default](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |
| [alicloud_instance_types.default](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/instance_types) | data source |
| [alicloud_ram_roles.roles](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/ram_roles) | data source |
| [alicloud_zones.default](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_spec"></a> [cluster\_spec](#input\_cluster\_spec) | The specification of the cluster | `string` | `"ack.pro.small"` | no |
| <a name="input_desired_size"></a> [desired\_size](#input\_desired\_size) | The desired number of nodes in the node pool | `number` | `3` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | The prefix for naming resources | `string` | `"ack-services-example"` | no |
| <a name="input_new_nat_gateway"></a> [new\_nat\_gateway](#input\_new\_nat\_gateway) | Whether to create a new NAT gateway | `bool` | `true` | no |
| <a name="input_region"></a> [region](#input\_region) | The region where resources will be created | `string` | `"cn-hangzhou"` | no |
| <a name="input_runtime_name"></a> [runtime\_name](#input\_runtime\_name) | The runtime name for containers | `string` | `"containerd"` | no |
| <a name="input_runtime_version"></a> [runtime\_version](#input\_runtime\_version) | The runtime version for containers | `string` | `"1.6.28"` | no |
| <a name="input_service_cidr"></a> [service\_cidr](#input\_service\_cidr) | The service CIDR block for the cluster | `string` | `"192.168.0.0/16"` | no |
| <a name="input_slb_internet_enabled"></a> [slb\_internet\_enabled](#input\_slb\_internet\_enabled) | Whether to enable internet SLB | `bool` | `true` | no |
| <a name="input_system_disk_category"></a> [system\_disk\_category](#input\_system\_disk\_category) | The category of system disk | `string` | `"cloud_essd"` | no |
| <a name="input_system_disk_size"></a> [system\_disk\_size](#input\_system\_disk\_size) | The size of system disk | `number` | `120` | no |
| <a name="input_template_url"></a> [template\_url](#input\_template\_url) | The URL of the ROS template | `string` | `"https://ros-public-templates.oss-cn-hangzhou.aliyuncs.com/ros-templates/documents/solution/micro/build-microservices-on-ack-k8s-resource.tf.yaml"` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | The CIDR block for the VPC | `string` | `"10.0.0.0/8"` | no |
| <a name="input_vswitch1_cidr_block"></a> [vswitch1\_cidr\_block](#input\_vswitch1\_cidr\_block) | The CIDR block for the first VSwitch | `string` | `"10.0.0.0/24"` | no |
| <a name="input_vswitch2_cidr_block"></a> [vswitch2\_cidr\_block](#input\_vswitch2\_cidr\_block) | The CIDR block for the second VSwitch | `string` | `"10.0.1.0/24"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_connections"></a> [cluster\_connections](#output\_cluster\_connections) | Map of kubernetes cluster connection information |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The ID of the ACK cluster |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the ACK cluster |
| <a name="output_created_ram_roles"></a> [created\_ram\_roles](#output\_created\_ram\_roles) | The list of created RAM role names |
| <a name="output_node_pool_id"></a> [node\_pool\_id](#output\_node\_pool\_id) | The ID of the node pool |
| <a name="output_ros_stack_id"></a> [ros\_stack\_id](#output\_ros\_stack\_id) | The ID of the ROS stack |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
<!-- END_TF_DOCS -->