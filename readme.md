
# 🚀 Terraform AWS EC2 Deployment

This repository contains Terraform configuration files to deploy an **EC2 instance** on AWS.

---

## 📂 Project Structure

```bash
.
├── .gitignore               # Git ignore rules
├── ec2.tf                   # EC2 instance definition
├── providers.tf             # AWS provider configuration
├── terraform.tf             # Main Terraform configuration
````

> ⚠️ Files like `ec2-terraform-key`, `ec2-terraform-key.pub`, and Terraform state files (`terraform.tfstate`, `terraform.tfstate.backup`) should **not** be committed.
> Make sure they are in `.gitignore`.

---

## 🔑 SSH Key Generation

Generate a key pair for EC2 SSH access:

```bash
ssh-keygen -t rsa -b 4096 -f ec2-terraform-key
```

This will create:

* `ec2-terraform-key` → private key (keep it safe, do not upload to GitHub)
* `ec2-terraform-key.pub` → public key (used in Terraform to configure EC2)

---

## ⚙️ Terraform Workflow

1. **Initialize Terraform**

   ```bash
   terraform init
   ```

2. **Validate configuration**

   ```bash
   terraform validate
   ```

3. **Preview execution plan**

   ```bash
   terraform plan
   ```

4. **Apply and create resources**

   ```bash
   terraform apply
   ```

5. **Destroy resources (when no longer needed)**

   ```bash
   terraform destroy
   ```

---

✅ That’s it! This repo will spin up an EC2 instance on AWS using Terraform.

```
