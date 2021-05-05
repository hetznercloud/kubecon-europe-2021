# KubeCon Europe 2021

This repository is part of a live demo at KubeCon Europe 2021 that shows how different official integrations can be used to deploy a Kubernetes (k3s) cluster at Hetzner Cloud.

The code in this repository creates chargeable resources (three servers and a load balancer) in your hcloud account. Please make sure to delete the resources afterwards to avoid unintended costs. If you attended KubeCon you received a coupon for some cloud credits which you can use to cover the costs to get started.

After the KubeCon this repository will not be updated or officially supported. If you think there is a bug with one of the integrations please feel free to open an issue in the corresponding GitHub repository or a customer ticket.

## Deploy Your Own Kubernetes Cluster

### 1. Setup

1. If you don't have an account yet, [create one](https://accounts.hetzner.com/signUp)
2. [Login](https://console.hetzner.cloud/) to your hcloud account
3. Redeem your cloud credits if you received some at the KubeCon
4. Create a new hcloud project
5. Go to the project settings at `Security > API Tokens` and create a new token with `Read & Write` access
6. Export the new token: `export HCLOUD_TOKEN=<your token>`
7. Clone the repository

```
git clone https://github.com/hetznercloud/kubecon-europe-2021.git
cd kubecon-europe-2021
```

### 2. Terraform

Replace the SSH public key in `terraform/hcloud.tf` with your own public key.

```
cd terraform
terraform init
terraform apply
```

### 3. Ansible

- Change the path to your SSH private key in the [inventory](./ansible/inventory/group_vars/all.yml).
- The `kubeconfig` role stores your kubeconfig at `~/.kube/config` [by default](./ansible/roles/kubeconfig/defaults/main.yml). To change the path you can override the `kubeconfig_local_path` variable (or change the yaml file).

```
cd ../ansible
pip install -r requirements.txt
ansible-galaxy install -r requirements.yml
ansible-playbook kubernetes.yml
```

## Interesting Links

- [More About Hetzner Cloud](https://www.hetzner.com/cloud)
- [Awesome hcloud](https://github.com/hetznercloud/awesome-hcloud)
- [Hetzner Cloud Developer Hub](https://developers.hetzner.com/cloud)
- [hcloud Documentation](https://docs.hetzner.com/cloud)
- [hcloud API](https://docs.hetzner.cloud/)
- [hcloud Terraform Provider](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs)
- [hcloud Ansible Collection](https://galaxy.ansible.com/hetzner/hcloud)
- [hcloud Cloud Controller Manager](https://github.com/hetznercloud/hcloud-cloud-controller-manager)
- [hcloud Container Storage Interface (CSI) Driver](https://github.com/hetznercloud/csi-driver)
- [k3s Website](https://k3s.io/)
- [k3s Documentation](https://rancher.com/docs/k3s/latest/en/)
