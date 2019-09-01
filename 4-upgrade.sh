#!/bin/bash
# Don't use this for now
# Upgrade to k8s 1.14.6
# echo "downloading rke v0.2.8 for k8s 1.14.6"
wget https://github.com/rancher/rke/releases/download/v0.2.8/rke_linux-amd64
chmod +x rke_linux-amd64
mv rke_linux-amd64 rke028
echo "replacing kubernetes: rancher/hyperkube:v1.14.6-rancher1"
sed -i -e "s/hyperkube:v1.13.5-rancher1/hyperkube:v1.14.6-rancher1/g" cluster.yml
cp .kube/config kube_config_cluster.yml
./rke028 up
cp kube_config_cluster.yml .kube/config
kubectl get nodes
echo "was that easy?"