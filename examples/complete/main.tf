provider "alicloud" {
  region = var.region
}

# Query available zones
data "alicloud_zones" "default" {
  available_instance_type    = data.alicloud_instance_types.default.ids[0]
  available_slb_address_type = "classic_internet"
}

# Query instance types
data "alicloud_instance_types" "default" {
  instance_type_family = "ecs.g7"
  sorted_by            = "CPU"
  memory_size          = "8"
}

# Query existing RAM roles to avoid duplication
data "alicloud_ram_roles" "roles" {
  policy_type = "Custom"
  name_regex  = "^Aliyun.*Role$"
}

# Generate random suffix for unique naming
resource "random_integer" "default" {
  min = 100000
  max = 999999
}

module "ack_services" {
  source = "../.."

  # VPC Configuration
  vpc = {
    vpc_name   = "${var.name_prefix}-vpc"
    cidr_block = var.vpc_cidr_block
  }

  # VSwitch Configuration (multi-zone for high availability)
  vswitches = [
    {
      zone_id      = data.alicloud_zones.default.zones[0].id
      cidr_block   = var.vswitch1_cidr_block
      vswitch_name = "${var.name_prefix}-vswitch1"
    },
    {
      zone_id      = data.alicloud_zones.default.zones[1].id
      cidr_block   = var.vswitch2_cidr_block
      vswitch_name = "${var.name_prefix}-vswitch2"
    }
  ]

  # Security Group Configuration
  security_group = {
    name = "${var.name_prefix}-sg"
    rules = [
      {
        type        = "ingress"
        ip_protocol = "tcp"
        port_range  = "80/80"
        cidr_ip     = var.vpc_cidr_block
      },
      {
        type        = "ingress"
        ip_protocol = "tcp"
        port_range  = "443/443"
        cidr_ip     = var.vpc_cidr_block
      }
    ]
  }

  # ACK Cluster Configuration
  ack_cluster = {
    name                 = "${var.name_prefix}-cluster"
    cluster_spec         = var.cluster_spec
    service_cidr         = var.service_cidr
    new_nat_gateway      = var.new_nat_gateway
    slb_internet_enabled = var.slb_internet_enabled
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

  # Node Pool Configuration
  node_pool = {
    name                 = "${var.name_prefix}-nodepool"
    instance_types       = [data.alicloud_instance_types.default.instance_types[0].id]
    system_disk_category = var.system_disk_category
    system_disk_size     = var.system_disk_size
    desired_size         = var.desired_size
    runtime_name         = var.runtime_name
    runtime_version      = var.runtime_version
  }

  # ROS Stack Configuration
  ros_stack = {
    name = "${var.name_prefix}-k8s-resource-${random_integer.default.result}"
  }

  # RAM Role Configuration
  ram_role = {
    existing_role_names = [for role in data.alicloud_ram_roles.roles.roles : role.name]
    force               = true
    policy_type         = "System"
  }
}