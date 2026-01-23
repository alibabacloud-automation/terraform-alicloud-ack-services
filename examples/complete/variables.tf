variable "region" {
  type        = string
  description = "The region where resources will be created"
  default     = "cn-shanghai"
}

variable "name_prefix" {
  type        = string
  description = "The prefix for naming resources"
  default     = "ack-services-example"
}

variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/8"
}

variable "vswitch1_cidr_block" {
  type        = string
  description = "The CIDR block for the first VSwitch"
  default     = "10.0.0.0/24"
}

variable "vswitch2_cidr_block" {
  type        = string
  description = "The CIDR block for the second VSwitch"
  default     = "10.0.1.0/24"
}

variable "cluster_spec" {
  type        = string
  description = "The specification of the cluster"
  default     = "ack.pro.small"
}

variable "service_cidr" {
  type        = string
  description = "The service CIDR block for the cluster"
  default     = "192.168.0.0/16"
}

variable "new_nat_gateway" {
  type        = bool
  description = "Whether to create a new NAT gateway"
  default     = true
}

variable "slb_internet_enabled" {
  type        = bool
  description = "Whether to enable internet SLB"
  default     = true
}

variable "system_disk_category" {
  type        = string
  description = "The category of system disk"
  default     = "cloud_essd"
}

variable "system_disk_size" {
  type        = number
  description = "The size of system disk"
  default     = 120
}

variable "desired_size" {
  type        = number
  description = "The desired number of nodes in the node pool"
  default     = 3
}

variable "runtime_name" {
  type        = string
  description = "The runtime name for containers"
  default     = "containerd"
}

variable "runtime_version" {
  type        = string
  description = "The runtime version for containers"
  default     = "1.6.28"
}

