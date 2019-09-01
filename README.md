# Rancher Kubernetes Engine and Rancher Server on LXC/LXD

## Why this?

There are some use cases for this implementation, e.g. companies who are running lXC containers on bare-metal and don't line VMs ;-)

## Prerequisites

Ubuntu 18.04 bionic 20190722.1

This setup was tested on AWS with Ubuntu 18.04 t2-xlarge instance (4vCPU, 16GB RAM) and an additional EBS volume (40 GB) on /dev/sdb using lxc with lvm

## Installation

Clone this repo and run the scripts as follow:

```bash
git clone https://github.com/arashkaffamanesh/lxc-rke-rancher.git
cd lxc-rke-rancher/
./1-deploy-lxc-containers.sh
./2-deploy-rke.sh
# if you're a cert-manager lover, please provide the right domain name and email address in 3-deploy-rancher-on-rke.sh
./3-deploy-rancher-on-rke.sh
# open port 443 in your security group and map your domain in dns
```

## What you get

You should get a running RKE Cluster on 3 LXCs with Rancher Server on top in less than 20 minutes.

## Access the Rancher Server on RKE

https://your domain name

## Blog post

Blog post will be published on medium:

https://blog.kubernauts.io/


