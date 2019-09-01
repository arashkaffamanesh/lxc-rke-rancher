# Rancher Kubernetes Engine and Rancher Server on LXC/LXD

## Prerequisites

Ubuntu 18.04 bionic 20190722.1

This setup was tested on AWS with Ubuntu 18.04 t2-xlarge instance (4vCPU, 16GB RAM) and an additional EBS volume (40 GB) on /dev/sdb using lxc with lvm

## Installation

Clone this repo and run the scripts as follow:

```bash
./1-deploy-lxc-containers.sh
./2-deploy-rke.sh
./3-deploy-rancher-on-rke.sh
```

## What you get

You should get a running RKE Cluster on 3 LXC with Rancher Server on top in less than 20 minutes.

## Blog post

Coming asap or never :-)


