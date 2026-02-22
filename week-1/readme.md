# 🏗️ Terraform — Infrastructure as Code (IaC)

---

## 📌 What is Terraform?

Terraform is an **Infrastructure as Code (IaC)** tool developed by HashiCorp, used to provision and manage infrastructure across multiple providers such as **AWS, Azure, GCP, VMware**, and many others — all using declarative configuration files.

Instead of manually creating infrastructure from the cloud console, Terraform allows you to **automate everything using code**.

---

## 📌 Use Case

Imagine you are asked to provision **10 virtual machines** with the same configuration across multiple regions or even different cloud providers.

Doing this manually would be:
- Time-consuming
- Error-prone
- Difficult to maintain

With Terraform, you can define the configuration **once** and deploy it **consistently anywhere**.

---

## 📌 Terraform Syntax Basics

Terraform uses configuration files written in **HCL (HashiCorp Configuration Language)**.

### General Syntax

```hcl
<block_type> <block_label> {
  <identifier> = <expression>
}
```

### Example

```hcl
resource "aws_instance" "example" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
}
```

| Component | Description |
|-----------|-------------|
| `block_type` | Type of block (`resource`, `provider`, `variable`, `output`) |
| `block_label` | Resource type and name |
| `identifier` | Argument/attribute name |
| `expression` | Value assigned |

---

## 📌 Core Concepts

### 1. Providers

A **provider** is a plugin that allows Terraform to interact with a cloud platform or service. You must configure a provider before using its resources.

```hcl
provider "aws" {
  region = "us-east-1"
}
```

Common providers:
- `hashicorp/aws` — Amazon Web Services
- `hashicorp/azurerm` — Microsoft Azure
- `hashicorp/google` — Google Cloud Platform
- `hashicorp/kubernetes` — Kubernetes clusters

---

### 2. Resources

A **resource** is the most important element in Terraform. It describes one or more infrastructure objects (VMs, databases, networks, etc.).

```hcl
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name"
  acl    = "private"
}
```

---

### 3. Variables

**Variables** make your configurations reusable and flexible. They act as inputs to your Terraform modules.

```hcl
# Declaration
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

# Usage
resource "aws_instance" "example" {
  ami           = "ami-12345678"
  instance_type = var.instance_type
}
```

**Variable Types:**
- `string` — text values
- `number` — numeric values
- `bool` — true/false
- `list(type)` — ordered collection
- `map(type)` — key-value pairs
- `object({})` — structured data

---

### 4. Outputs

**Outputs** expose values from your infrastructure after it's been created. Useful for sharing data between modules or displaying important info.

```hcl
output "instance_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.example.public_ip
}
```

---

### 5. Data Sources

**Data sources** allow Terraform to **read** existing infrastructure that is not managed by the current configuration.

```hcl
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
}
```

---

### 6. Locals

**Locals** allow you to assign names to expressions for reuse within your configuration.

```hcl
locals {
  environment = "production"
  app_name    = "my-app"
  common_tags = {
    Environment = local.environment
    App         = local.app_name
    ManagedBy   = "Terraform"
  }
}

resource "aws_instance" "example" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
  tags          = local.common_tags
}
```

---

### 7. Modules

**Modules** are containers for multiple resources that are used together. They allow you to package and reuse Terraform code.

```hcl
# Calling a module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
}
```

Modules can come from:
- Local paths (`./modules/vpc`)
- The [Terraform Registry](https://registry.terraform.io/)
- Git repositories

---

## 📌 Terraform State

Terraform uses a **state file** (`terraform.tfstate`) to keep track of what infrastructure it manages.

| Concept | Description |
|---------|-------------|
| **Local state** | Stored on your machine (default) |
| **Remote state** | Stored in S3, Azure Blob, GCS, Terraform Cloud |
| **State locking** | Prevents concurrent modifications (via DynamoDB, etc.) |

### Remote Backend Example (AWS S3)

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
```

> ⚠️ **Never commit `terraform.tfstate` to version control.** It may contain sensitive data.

---

## 📌 Terraform Workflow

```
terraform init       # Download providers & initialize the working directory
terraform plan       # Preview changes before applying
terraform apply      # Apply changes to real infrastructure
terraform destroy    # Tear down all managed infrastructure
```

### Workflow Diagram

```
Write Config (.tf files)
         ↓
terraform init
         ↓
terraform plan   ← Shows what WILL change
         ↓
terraform apply  ← Makes changes to infrastructure
         ↓
terraform destroy (when done)
```

---

## 📌 Meta-Arguments

Meta-arguments modify the behavior of resources. They apply to any resource type.

### `count` — Create Multiple Resources

```hcl
resource "aws_instance" "server" {
  count         = 3
  ami           = "ami-12345678"
  instance_type = "t2.micro"
  tags = {
    Name = "server-${count.index}"
  }
}
```

### `for_each` — Create Resources from a Map or Set

```hcl
resource "aws_iam_user" "user" {
  for_each = toset(["alice", "bob", "charlie"])
  name     = each.key
}
```

### `depends_on` — Explicit Dependency

```hcl
resource "aws_instance" "app" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
  depends_on    = [aws_db_instance.database]
}
```

### `lifecycle` — Control Resource Behavior

```hcl
resource "aws_instance" "example" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = true
    ignore_changes        = [ami]
  }
}
```

---

## 📌 Terraform Functions

HCL includes built-in functions for transforming and combining values.

```hcl
# String functions
upper("hello")         # → "HELLO"
lower("WORLD")         # → "world"
format("Hello, %s!", "Terraform")

# Collection functions
length(["a", "b", "c"])      # → 3
merge({a=1}, {b=2})          # → {a=1, b=2}
toset(["x", "x", "y"])      # → {"x", "y"}

# Numeric functions
max(5, 12, 9)                # → 12
min(5, 12, 9)                # → 5

# Encoding
base64encode("hello world")
jsonencode({name = "terraform"})
```

---

## 📌 File Structure Best Practices

```
project/
├── main.tf          # Primary resources
├── variables.tf     # Input variable declarations
├── outputs.tf       # Output value declarations
├── providers.tf     # Provider configuration
├── locals.tf        # Local values
├── versions.tf      # Required Terraform/provider versions
├── terraform.tfvars # Variable values (do not commit secrets!)
└── modules/
    └── vpc/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

## 📌 Useful CLI Commands

| Command | Description |
|---------|-------------|
| `terraform init` | Initialize the directory |
| `terraform validate` | Check configuration syntax |
| `terraform plan` | Preview changes |
| `terraform apply` | Apply changes |
| `terraform destroy` | Destroy infrastructure |
| `terraform fmt` | Format code to canonical style |
| `terraform show` | Display current state |
| `terraform output` | Print output values |
| `terraform import` | Import existing infrastructure into state |
| `terraform state list` | List all resources in state |
| `terraform graph` | Generate a visual dependency graph |

---

## 📌 Summary

| Concept | Purpose |
|---------|---------|
| **Provider** | Connects Terraform to a cloud/service |
| **Resource** | Infrastructure object to create/manage |
| **Variable** | Input parameter for reusability |
| **Output** | Expose values after deployment |
| **Data Source** | Read existing infrastructure |
| **Local** | Reusable expression aliases |
| **Module** | Reusable group of resources |
| **State** | Tracks managed infrastructure |
| **Backend** | Where state is stored |
| **Meta-arguments** | Control resource behavior (`count`, `for_each`, etc.) |