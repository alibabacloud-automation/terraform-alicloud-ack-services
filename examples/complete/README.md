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
