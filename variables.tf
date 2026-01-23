variable "vpc" {
  type = object({
    cidr_block = string
    vpc_name   = optional(string, null)
  })
  description = "VPC configuration"
}

variable "vswitches" {
  type = list(object({
    zone_id      = string
    cidr_block   = string
    vswitch_name = optional(string, null)
  }))
  description = "List of vswitch configurations. At least two vswitches in different zones are required. Each vswitch must specify zone_id (cannot be changed after creation), cidr_block, and vswitch_name."

  validation {
    condition     = length(var.vswitches) >= 2
    error_message = "At least two vswitchs must be configured."
  }
}

variable "security_group" {
  type = object({
    name = optional(string, null)
    rules = list(object({
      type        = string
      ip_protocol = string
      port_range  = string
      cidr_ip     = string
    }))
  })
  description = "Security group configuration including name and rules"
  default = {
    rules = [
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
  }
}

variable "ack_cluster" {
  type = object({
    name                 = string
    cluster_spec         = string
    service_cidr         = string
    new_nat_gateway      = bool
    slb_internet_enabled = bool
    addons = list(object({
      name     = string
      config   = string
      version  = string
      disabled = bool
    }))
    delete_options = list(object({
      delete_mode   = string
      resource_type = string
    }))
  })
  description = "ACK managed Kubernetes cluster configuration"
  default = {
    name                 = "ack-services-cluster"
    cluster_spec         = "ack.pro.small"
    service_cidr         = "192.168.0.0/16"
    new_nat_gateway      = true
    slb_internet_enabled = true
    addons = [
      {
        name     = "ack-node-local-dns"
        config   = ""
        version  = ""
        disabled = false
      },
      {
        name     = "terway-eniip"
        config   = "{\"IPVlan\":\"false\",\"NetworkPolicy\":\"false\",\"ENITrunking\":\"false\"}"
        version  = ""
        disabled = false
      },
      {
        name     = "csi-plugin"
        config   = ""
        version  = ""
        disabled = false
      },
      {
        name     = "csi-provisioner"
        config   = ""
        version  = ""
        disabled = false
      },
      {
        name     = "storage-operator"
        config   = "{\"CnfsOssEnable\":\"false\",\"CnfsNasEnable\":\"false\"}"
        version  = ""
        disabled = false
      },
      {
        name     = "nginx-ingress-controller"
        config   = ""
        version  = ""
        disabled = true
      },
      {
        name     = "logtail-ds"
        config   = "{\"IngressDashboardEnabled\":\"true\"}"
        version  = ""
        disabled = false
      },
      {
        name     = "alb-ingress-controller"
        config   = "{\"albIngress\":{\"AddressType\":\"Internet\",\"CreateDefaultALBConfig\":true}}"
        version  = ""
        disabled = false
      }
    ]
    delete_options = [
      {
        delete_mode   = "delete"
        resource_type = "ALB"
      },
      {
        delete_mode   = "delete"
        resource_type = "SLB"
      },
      {
        delete_mode   = "delete"
        resource_type = "SLS_Data"
      },
      {
        delete_mode   = "delete"
        resource_type = "SLS_ControlPlane"
      },
      {
        delete_mode   = "delete"
        resource_type = "PrivateZone"
      }
    ]
  }
}

variable "node_pool" {
  type = object({
    name                 = string
    instance_types       = list(string)
    system_disk_category = string
    system_disk_size     = number
    desired_size         = number
    runtime_name         = string
    runtime_version      = string
  })
  description = "Node pool configuration for the ACK cluster"
  default = {
    name                 = "ack-services-nodepool"
    instance_types       = ["ecs.g7.large"]
    system_disk_category = "cloud_essd"
    system_disk_size     = 120
    desired_size         = 3
    runtime_name         = "containerd"
    runtime_version      = "1.6.28"
  }
}

variable "ros_stack" {
  type = object({
    name             = string
    template_url     = optional(string, "https://ros-public-templates.oss-cn-hangzhou.aliyuncs.com/ros-templates/documents/solution/micro/build-microservices-on-ack-k8s-resource.tf.yaml")
    disable_rollback = optional(bool, true)
    parameters = optional(list(object({
      parameter_key   = string
      parameter_value = string
    })), null)
  })
  description = "ROS stack configuration for K8s resources"
  default = {
    name = "ack-services-k8s-resource-stack"
  }
}

variable "ram_role" {
  type = object({
    existing_role_names = list(string)
    force               = optional(bool, true)
    policy_type         = optional(string, "System")
  })
  description = "RAM role configuration"
  default = {
    existing_role_names = []
  }
}
