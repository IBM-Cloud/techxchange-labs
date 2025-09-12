# 🏗️ Building the Infrastructure with Terraform Modules

Now that the environment is set up, you will build the hub-and-spoke infrastructure step-by-step. You will add blocks of Terraform code to your `main.tf` file to provision the necessary resources.

## What are `terraform-ibm-modules`?

To accelerate development and ensure best practices, we will use pre-built, open-source **Terraform modules** from IBM Cloud, available on the [`terraform-ibm-modules`](https://github.com/terraform-ibm-modules) GitHub organization. These modules simplify the creation of complex resources and enforce IBM Cloud's recommended security and architecture patterns.

## Step 1: Create a Resource Group

A resource group is a logical container for your IBM Cloud resources, which helps with organization and access management.

Add the following code to your `main.tf` file:

```hcl
module "resource_group" {
  source              = "terraform-ibm-modules/resource-group/ibm"
  version             = "1.3.0"
  resource_group_name = "${var.prefix}-management-workload-rg"
}
```

## Step 2: Create the Management VPC (The Hub)

The Management VPC acts as the secure entry point to your environment. It will host the jumpbox server and has controlled access to the internet. We use the [terraform-ibm-landing-zone-vpc](https://github.com/terraform-ibm-modules/terraform-ibm-landing-zone-vpc) module to create the VPC, its subnets across three availability zones, and the necessary network ACLs.

Add the following code to `main.tf`:

```hcl
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
        source      = "10.10.0.0/20"  # workload vpc range
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
```

### Understanding the Code
-   **High Availability and Resiliency**: Notice that we are defining subnets in three different zones (`zone-1`, `zone-2`, and `zone-3`). These correspond to different Availability Zones (AZs) within the `us-south` region. An AZ is a physically separate data center. By spreading our infrastructure across multiple AZs, we ensure that our application remains available even if one entire data center experiences an outage. This is a fundamental principle for building resilient cloud architectures.
-   **CIDR Ranges**: We are using the `10.0.0.0/20` address space for this VPC, which provides over 4,000 IP addresses. This space is subdivided into smaller `/22` ranges for each subnet (e.g., `10.0.0.0/22`, `10.0.4.0/22`). This is a standard practice in network design, providing plenty of addresses for resources within each availability zone while keeping the ranges logically separated.
-   **Public Gateway vs. Floating IP**: It's important to understand the two types of internet connectivity used here:
    -   A **Floating IP** will be attached directly to our jumpbox server in a later step. This provides a static public IP address and allows **inbound** connections to the server (e.g., for you to connect via SSH).
    -   The **`public_gateway = true`** setting allows resources within the subnet to initiate **outbound** connections to the internet. This is a best practice for a jumpbox, which typically needs to download software or security updates.
-   **`network_acls`**: A Network ACL is a stateless firewall that controls traffic in and out of subnets. The `landing-zone-vpc` module simplifies ACL management. By setting `add_ibm_cloud_internal_rules` and `add_vpc_connectivity_rules` to `true`, the module automatically creates a baseline of rules that allow all traffic between subnets within the same VPC and permit access to common IBM Cloud services (like DNS). We then add our own custom rules on top of this baseline:
    -   `allow-ssh-from-internet`: This allows inbound SSH traffic (port 22) from any IP address (`0.0.0.0/0`) so you can connect to the jumpbox.
    -   `allow-http-from-internet`: This allows inbound HTTP traffic (port 80) from any IP address. This is necessary for our public load balancer to receive traffic.
    -   `allow-workload-to-management-traffic`: This allows the private Workload VPC (`10.10.0.0/20`) to initiate connections back to the Management VPC.
    -   `allow-all-outbound-traffic`: This allows resources inside the Management VPC, like the jumpbox, to connect to any external address.

## Step 3: Create the Workload VPC (The Spoke)

The Workload VPC will host the application servers. It is designed to be private, with no direct internet access, to enhance security.

Add the following code to `main.tf`:

```hcl
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
```
### Understanding the Code
-   **CIDR Ranges**: The Workload VPC uses the `10.10.0.0/20` address space. It's important that this range does not overlap with the Management VPC's range (`10.0.0.0/20`) to ensure proper routing between them.
-   **`public_gateway = false`**: This is the key security feature. By setting this to `false`, the virtual servers in this VPC cannot initiate connections to the public internet, nor can they be reached from it directly.
-   **`network_acls`**: The rules are configured to only allow traffic between the Management VPC (`10.0.0.0/20`) and this Workload VPC (`10.10.0.0/20`). All other traffic is implicitly denied by default, creating a secure, isolated environment for the application servers.

## Step 4: Connect the VPCs with a Transit Gateway

To enable private communication between the Management and Workload VPCs, you will create a **Transit Gateway**.

Add the following code to `main.tf`:

```hcl
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
```

## Step 5: Deploy the Network Foundation

At this point, you have defined the core network infrastructure: two VPCs and a Transit Gateway to connect them. Let's deploy these resources. This is a good time to apply your changes, as it allows you to verify the network foundation before adding the compute resources.

1. **Run `terraform init`**
    
    As you have already executed this command earlier in the previous step, running again this command now searches for `module` blocks, and the source code for referenced modules is retrieved from the locations given in their `source` arguments.
    
    ```bash
   terraform init
    ```
 
2. **Run `terraform plan`**

    This command creates an execution plan. It's a great way to check for errors and verify what will be created.

    ```bash
    terraform plan
    ```

    You should see a plan to add the resource group, both VPCs, and the transit gateway.

3. **Run `terraform apply`**

    This command applies the plan and builds the network infrastructure.

    ```bash
    terraform apply
    ```

    Terraform will ask for your confirmation. Type `yes` and press Enter.

    The provisioning process for the network can take a few minutes (typically less than 10 minutes). Once complete, you can go to the [VPC console](https://cloud.ibm.com/vpc-ext/network/vpcs) in the Target Deployment IBM Cloud Account to see your newly created `management` and `workload` VPCs.
   
---

Now that the network foundation is in place, you will add the compute resources (virtual servers), load balancers, and other services.

## Step 6: Create an SSH Key for Server Access

You need an SSH key pair to securely connect to the virtual servers. The following code will generate a new key pair, upload the public key to IBM Cloud, and save the private key locally to a file named `<YOUR-PREFIX>_ssh_private_key.pem`.

Add the following code to `main.tf`:

```hcl
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

# ONLY outputs private file name
output "ssh_private_key_file_name" {
  description = "Private key file name."
  value = "${var.prefix}_ssh_private_key.pem"
}

resource "ibm_is_ssh_key" "ssh_key" {
  name       = "${var.prefix}-ssh-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}
```
> **Security Note:** Saving private keys directly to the filesystem is done here for lab simplicity. In a production environment, you should use a secure secret management tool like IBM Cloud Secrets Manager.

## Step 7: Provision the Jumpbox Server

Now, provision the **jumpbox server** in the Management VPC. It will have a public IP address so you can connect to it.

Add the following code to `main.tf`:

```hcl
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
```

### Understanding the Code
- **Security Groups vs. Network ACLs**: In this step, the `landing-zone-vsi` module creates a **Security Group** for the jumpbox. It's important to understand the difference between the two VPC firewalls:
    - **Network ACLs** (that you configured earlier) are **stateless** and operate at the **subnet level**. You need to define rules for both inbound and outbound traffic explicitly.
    - **Security Groups** are **stateful** and operate at the **instance (VSI) level**. If you allow an inbound connection, the outbound return traffic is automatically permitted, which simplifies rule management. They act as a virtual firewall for your servers.
- **`enable_floating_ip = true`**: This is where the magic happens for inbound connectivity. The module automatically provisions and attaches a public Floating IP to the jumpbox, making it accessible from the internet on the IP address that will be shown in the `jumpbox_public_ip` output.

## Step 8: Provision the Workload Servers and Private Load Balancer

Next, provision the **workload servers** in the private Workload VPC. The [terraform-ibm-landing-zone-vsi](https://github.com/terraform-ibm-modules/terraform-ibm-landing-zone-vsi) module will also create a **private load balancer** to distribute traffic to these servers.

Add the following code to `main.tf`:

```hcl
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
```

## Step 9: Provision the Public Load Balancer

To expose the application to the internet, you will create a **public load balancer** in the Management VPC. It will receive public traffic and forward it to the *private* load balancer in the Workload VPC.

### Understanding the Architecture: Load Balancer Chaining
This configuration demonstrates a common and secure cloud design pattern called **Load Balancer Chaining**.
-   The **Public Load Balancer** acts as the secure entry point. It lives in the Management VPC and is the only component exposed to the public internet.
-   It then forwards traffic to the **Private Load Balancer** in the isolated Workload VPC.
-   This ensures that the workload servers are never directly exposed to the internet, significantly reducing the attack surface.

Add the following code to `main.tf`:

```hcl
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

resource "ibm_is_lb_listener" "public_lb_listener" {
  lb           = ibm_is_lb.public_load_balancer.id
  port         = 80
  protocol     = "http"
  default_pool = ibm_is_lb_pool.public_lb_pool.id
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

output "public_load_balancer_hostname" {
  description = "Public hostname to access the application through the load balancer"
  value       = ibm_is_lb.public_load_balancer.hostname
}
```

## Step 10: Provision Virtual Private Endpoints (VPEs)

To allow the private workload servers to securely access IBM Cloud services like Cloud Object Storage, you will create a **Virtual Private Endpoint (VPE)**. This keeps traffic on the private IBM Cloud network.

Add the following code to `main.tf`:

```hcl
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

module "workload_vpes" {
  source             = "terraform-ibm-modules/vpe-gateway/ibm"
  region             = "us-south"
  prefix             = "${var.prefix}-workload-vpe"
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

output "workload_vpe_ips_1" {
  description = "One of the Private IP addresses of VPC endpoints for cloud services"
  value = flatten([for vpe_ips in module.workload_vpes.vpe_ips : [for ip in vpe_ips : ip.address]])[0]
}
```

## Step 11: Provision Cloud Object Storage

Finally, create a **Cloud Object Storage (COS)** instance and a bucket to store application data.

Add the following code to `main.tf`:

```hcl
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

output "cos_instance_crn" {
  description = "COS instance CRN"
  value       = module.cos_storage.cos_instance_crn
}

output "bucket_name" {
  description = "Bucket name"
  value       = module.cos_storage.bucket_name
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
```

## Step 12: Deploy the Compute and Service Resources

Your `main.tf` file is now complete with all compute, load balancing, and storage resources. Let's deploy them.

1. **Run `terraform init`**
    
    Run init again to download new modules added to the code.
    
    ```bash
    terraform init
    ```
   
2. **Run `terraform plan`**

    Run plan again to see the new resources that will be added.

    ```bash
    terraform plan
    ```

    You should see a plan to add the SSH key, virtual servers, load balancers, VPEs, and the COS instance.

3. **Run `terraform apply`**

    This command applies the plan and builds the remaining infrastructure.

    ```bash
    terraform apply
    ```

    Terraform will ask for your confirmation. Type `yes` and press Enter.

    The provisioning process will take several minutes (typically 10-15 minutes).

4. **Review the Outputs**

    Once the `apply` is complete, Terraform will display all the outputs, including the jumpbox IP and load balancer hostname. You will use these in the next section to test your deployment.

**Congratulations!** You have successfully built a secure hub-and-spoke architecture on IBM Cloud.

---

[Next: Testing End-to-End Connectivity](./05-testing-connectivity-applications.md)
