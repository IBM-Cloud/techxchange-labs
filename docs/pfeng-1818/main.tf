variable "ibmcloud_api_key" {
  description = "IBM Cloud API key for authentication and resource provisioning"
  type        = string
  sensitive   = true
}

variable "prefix" {
  description = "Unique prefix for resource naming (e.g., 'jdoe-demo' or 'team-dev')"
  type        = string
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = "us-south"
}

terraform {
  required_version = ">= 1.9.0"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = ">= 1.80.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9.1, < 1.0.0"
    }
  }
}

module "resource_group" {
  source              = "terraform-ibm-modules/resource-group/ibm"
  version             = "1.3.0"
  resource_group_name = "${var.prefix}-management-workload-rg"
}

module "management_vpc" {
  source            = "terraform-ibm-modules/landing-zone-vpc/ibm"
  version           = "8.0.0"
  resource_group_id = module.resource_group.resource_group_id
  region            = "us-south"
  name              = "${var.prefix}-management-vpc"
  network_acls = [{
    name                         = "management-network-acl"
    add_ibm_cloud_internal_rules = true
    add_vpc_connectivity_rules   = true
    prepend_ibm_rules            = true
    rules = [
      {
        name      = "allow-ssh-from-internet"
        action    = "allow"
        direction = "inbound"
        tcp = {
          port_min = 22
          port_max = 22
        }
        source      = "0.0.0.0/0"
        destination = "0.0.0.0/0"
      },
      {
        name      = "allow-http-from-internet"
        action    = "allow"
        direction = "inbound"
        tcp = {
          port_min = 80
          port_max = 80
        }
        source      = "0.0.0.0/0"
        destination = "0.0.0.0/0"
      },
      {
        name        = "allow-workload-to-management-traffic"
        action      = "allow"
        direction   = "inbound"
        source      = "10.10.0.0/20" # workload vpc range
        destination = "0.0.0.0/0"
      },
      {
        name        = "allow-all-outbound-traffic"
        action      = "allow"
        direction   = "outbound"
        destination = "0.0.0.0/0"
        source      = "0.0.0.0/0"
      }
    ]
  }]
  subnets = {
    zone-1 = [
      {
        name           = "management-subnet-zone1"
        cidr           = "10.0.0.0/22"
        public_gateway = true
        acl_name       = "management-network-acl"
      }
    ],
    zone-2 = [
      {
        name           = "management-subnet-zone2"
        cidr           = "10.0.4.0/22"
        public_gateway = true
        acl_name       = "management-network-acl"
      }
    ],
    zone-3 = [
      {
        name           = "management-subnet-zone3"
        cidr           = "10.0.8.0/22"
        public_gateway = true
        acl_name       = "management-network-acl"
      }
    ]
  }
}

module "workload_vpc" {
  source            = "terraform-ibm-modules/landing-zone-vpc/ibm"
  version           = "8.0.0"
  resource_group_id = module.resource_group.resource_group_id
  region            = "us-south"
  name              = "${var.prefix}-workload-vpc"
  network_acls = [{
    name                         = "workload-network-acl"
    add_ibm_cloud_internal_rules = true
    add_vpc_connectivity_rules   = true
    prepend_ibm_rules            = true
    rules = [
      {
        name        = "allow-management-to-workload-traffic"
        action      = "allow"
        direction   = "inbound"
        source      = "10.0.0.0/20"  # management vpc range
        destination = "10.10.0.0/20" # workload vpc range
      },
      {
        name        = "allow-workload-to-management-traffic"
        action      = "allow"
        direction   = "outbound"
        source      = "10.10.0.0/20" # workload vpc range
        destination = "10.0.0.0/20"  # management vpc range
      }
    ]
  }]
  subnets = {
    zone-1 = [
      {
        name           = "workload-subnet-zone1"
        cidr           = "10.10.0.0/22"
        public_gateway = false # No direct internet access for security
        acl_name       = "workload-network-acl"
      }
    ],
    zone-2 = [
      {
        name           = "workload-subnet-zone2"
        cidr           = "10.10.4.0/22"
        public_gateway = false
        acl_name       = "workload-network-acl"
      }
    ],
    zone-3 = [
      {
        name           = "workload-subnet-zone3"
        cidr           = "10.10.8.0/22"
        public_gateway = false
        acl_name       = "workload-network-acl"
      }
    ]
  }
}

module "transit_gateway" {
  source                    = "terraform-ibm-modules/transit-gateway/ibm"
  version                   = "2.5.1"
  transit_gateway_name      = "${var.prefix}-management-workload-tg"
  region                    = "us-south"
  global_routing            = false
  resource_group_id         = module.resource_group.resource_group_id
  vpc_connections           = [{ vpc_crn = module.management_vpc.vpc_crn }, { vpc_crn = module.workload_vpc.vpc_crn }]
  classic_connections_count = 0
}

# Generate SSH key pair for secure server access
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Store private key locally (LAB ONLY - use secure key management in production)
resource "local_file" "ssh_private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.module}/${var.prefix}_ssh_private_key.pem"
  file_permission = "0600" # Read-only for owner
}

resource "ibm_is_ssh_key" "ssh_key" {
  name       = "${var.prefix}-ssh-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

module "jumpbox_server" {
  source                = "terraform-ibm-modules/landing-zone-vsi/ibm"
  version               = "v5.4.18"
  create_security_group = true
  image_id              = "r006-ca75f893-8675-47b0-b35d-9f847abc95e3" # Debian 12 minimal
  enable_floating_ip    = true
  security_group = {
    name = "jumpbox-security-group"
    rules = [
      {
        name      = "allow-ssh-from-internet"
        direction = "inbound"
        source    = "0.0.0.0/0" # Restrict to your IP in production
        tcp = {
          port_min = 22
          port_max = 22
        }
        udp  = null
        icmp = null
      },
      {
        name        = "allow-ssh-to-workload-servers"
        direction   = "outbound"
        source      = "0.0.0.0/0"
        destination = "10.10.0.0/20" # workload VPC range
        tcp = {
          port_min = 22
          port_max = 22
        }
      },
      {
        name        = "allow-ping-to-workload-servers"
        direction   = "outbound"
        source      = "0.0.0.0/0"
        destination = "10.10.0.0/20" # workload VPC range
        icmp = {
          type = 8 # Echo request (ping)
          code = 0
        }
      }
    ]
  }
  machine_type      = "cx2-2x4"
  prefix            = "${var.prefix}-jumpbox"
  resource_group_id = module.resource_group.resource_group_id
  ssh_key_ids       = [ibm_is_ssh_key.ssh_key.id]
  subnets           = [module.management_vpc.subnet_zone_list[0]]
  user_data         = null
  vpc_id            = module.management_vpc.vpc_id
  vsi_per_subnet    = 1
}

output "jumpbox_public_ip" {
  description = "Public IP address to connect to the jumpbox server"
  value       = module.jumpbox_server.fip_list[0].floating_ip
}

module "workload_servers" {
  source                = "terraform-ibm-modules/landing-zone-vsi/ibm"
  version               = "v5.4.18"
  create_security_group = true
  image_id              = "r006-ca75f893-8675-47b0-b35d-9f847abc95e3" # Debian 12 minimal
  security_group = {
    name = "workload-server-security-group"
    rules = [
      {
        name      = "allow-ssh-from-jumpbox"
        direction = "inbound"
        source    = module.management_vpc.subnet_zone_list[0].cidr
        tcp = {
          port_min = 22
          port_max = 22
        }
        udp  = null
        icmp = null
      },
      {
        name      = "allow-ping-from-jumpbox"
        direction = "inbound"
        source    = module.management_vpc.subnet_zone_list[0].cidr
        icmp = {
          type = 8 # Echo request (ping)
          code = 0
        }
      },
      {
        name      = "allow-dns-resolution"
        direction = "outbound"
        source    = null
        tcp       = null
        udp = {
          port_min = 53
          port_max = 53
        }
        icmp = null
      },
      {
        name      = "allow-https-api-calls"
        direction = "outbound"
        source    = null
        tcp = {
          port_min = 443
          port_max = 443
        }
        udp  = null
        icmp = null
      },
      {
        name      = "allow-loadbalancer-to-app"
        direction = "inbound"
        source    = "10.10.0.0/20" # workload vpc range - private LB located here
        tcp = {
          port_min = 8080 # application port
          port_max = 8080
        }
        udp  = null
        icmp = null
      }
    ]
  }
  load_balancers = [{
    name                       = "${var.prefix}-private-lb"
    type                       = "private"
    algorithm                  = "round_robin"
    protocol                   = "http"
    listener_protocol          = "http"
    listener_port              = 80
    pool_member_port           = "8080"
    health_type                = "http"
    connection_limit           = 80
    health_delay               = 5
    health_retries             = 3
    health_timeout             = 2
    subnet_id_to_provision_nlb = module.workload_vpc.subnet_zone_list[0].id

    security_group = {
      name = "private-loadbalancer-security-group"
      rules = [
        {
          name      = "allow-http-from-management"
          direction = "inbound"
          source    = "10.0.0.0/20" # management CIDR
          tcp = {
            port_min = 80
            port_max = 80
          }
        },
        {
          name        = "allow-lb-to-workload-servers"
          source      = "0.0.0.0/0"
          direction   = "outbound"
          destination = "10.10.0.0/20" # workload vpc range
          tcp = {
            port_min = 8080
            port_max = 8080
          }
        }
      ]
    }
  }]
  machine_type      = "cx2-2x4"
  prefix            = "${var.prefix}-workload"
  resource_group_id = module.resource_group.resource_group_id
  ssh_key_ids       = [ibm_is_ssh_key.ssh_key.id]
  subnets           = module.workload_vpc.subnet_zone_list
  user_data         = null
  vpc_id            = module.workload_vpc.vpc_id
  vsi_per_subnet    = 1
}

output "workload_server_private_ips" {
  description = "Private IP addresses of the workload servers"
  value       = module.workload_servers.list[*].ipv4_address
}

output "public_load_balancer_hostname" {
  description = "Public hostname to access the application through the load balancer"
  value       = ibm_is_lb.public_load_balancer.hostname
}

resource "ibm_is_lb" "public_load_balancer" {
  name           = "${var.prefix}-public-lb"
  subnets        = module.management_vpc.subnet_ids
  type           = "public"
  resource_group = module.resource_group.resource_group_id
}

resource "ibm_is_lb_pool" "public_lb_pool" {
  lb                 = ibm_is_lb.public_load_balancer.id
  name               = "public-lb-pool"
  protocol           = "http"
  algorithm          = "round_robin"
  health_delay       = 5
  health_retries     = 2
  health_timeout     = 2
  health_type        = "http"
  health_monitor_url = "/"
}

resource "ibm_is_lb_pool_member" "private_lb_target" {
  lb             = ibm_is_lb.public_load_balancer.id
  pool           = element(split("/", ibm_is_lb_pool.public_lb_pool.id), 1)
  port           = 80
  target_address = "10.10.4.6" # Private load balancer IP in workload VPC zone 2
}

module "public_lb_security_group" {
  source                       = "terraform-ibm-modules/security-group/ibm"
  version                      = "2.7.0"
  add_ibm_cloud_internal_rules = true
  security_group_name          = "public-lb-security-group"
  security_group_rules = [{
    name      = "allow-http-from-internet"
    direction = "inbound"
    remote    = "0.0.0.0/0"
    port_min  = 80
    port_max  = 80
  }]
  vpc_id     = module.management_vpc.vpc_id
  target_ids = [ibm_is_lb.public_load_balancer.id]
}


module "workload_vpe_security_group" {
  source              = "terraform-ibm-modules/security-group/ibm"
  version             = "2.7.0"
  security_group_name = "workload-vpe-security-group"
  resource_group      = module.resource_group.resource_group_id
  vpc_id              = module.workload_vpc.vpc_id

  security_group_rules = [
    {
      name      = "allow-workload-to-cloud-services"
      direction = "inbound"
      remote    = "10.10.0.0/20" # workload VPC range
      tcp       = { port_min = 443, port_max = 443 }
    }
  ]
}

resource "ibm_is_lb_listener" "public_lb_listener" {
  lb           = ibm_is_lb.public_load_balancer.id
  port         = 80
  protocol     = "http"
  default_pool = ibm_is_lb_pool.public_lb_pool.id
}

module "workload_vpes" {
  source             = "terraform-ibm-modules/vpe-gateway/ibm"
  region             = "us-south"
  prefix             = "workload-vpe"
  vpc_name           = module.workload_vpc.vpc_name
  vpc_id             = module.workload_vpc.vpc_id
  subnet_zone_list   = module.workload_vpc.subnet_zone_list
  resource_group_id  = module.resource_group.resource_group_id
  security_group_ids = [module.workload_vpe_security_group.security_group_id]

  cloud_services = [
    {
      service_name                 = "cloud-object-storage",
      allow_dns_resolution_binding = true
    }
  ]
}

output "workload_vpe_ips" {
  description = "Private IP addresses of VPC endpoints for cloud services"
  value       = module.workload_vpes.vpe_ips
}

module "cos_storage" {
  source                 = "terraform-ibm-modules/cos/ibm"
  resource_group_id      = module.resource_group.resource_group_id
  region                 = "us-south"
  cos_instance_name      = "${var.prefix}-cos-storage"
  bucket_name            = "${var.prefix}-data-bucket"
  retention_enabled      = false # Disabled for lab - enable for production
  kms_encryption_enabled = false
  resource_keys = [{
    name                      = "workload-service-credentials"
    generate_hmac_credentials = true
    role                      = "Reader"
  }]
}

output "cos_access_key_id" {
  sensitive   = true
  description = "Access key ID for Cloud Object Storage (S3-compatible)"
  value       = module.cos_storage.resource_keys["workload-service-credentials"]["credentials"]["cos_hmac_keys.access_key_id"]
}

output "cos_secret_access_key" {
  sensitive   = true
  description = "Secret access key for Cloud Object Storage (S3-compatible)"
  value       = module.cos_storage.resource_keys["workload-service-credentials"]["credentials"]["cos_hmac_keys.secret_access_key"]
}

