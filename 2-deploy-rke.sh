#!/bin/bash

# rm -fv kube_config_cluster.yml

echo "downloading rke v0.1.18 for k8s 1.13.5"
# wget https://github.com/rancher/rke/releases/download/v0.1.18/rke_linux-amd64
wget https://github.com/rancher/rke/releases/download/v0.2.8/rke_linux-amd64
mv rke_linux-amd64 rke
sudo chmod +x rke
sudo mv rke /usr/local/bin/
rke --version

rke up --config cluster.yml

echo "downloading kubectl"
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.15.0/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/
[ -d /home/ubuntu/.kube ] || mkdir /home/ubuntu/.kube
mv kube_config_cluster.yml /home/ubuntu/.kube/config
kubectl get nodes
echo "are the nodes ready?"
echo "if you face problems, please open an issue on github"

# Upgrade to k8s 1.14.6
# echo "download rke v0.2.8 for k8s 1.14.6"
# wget https://github.com/rancher/rke/releases/download/v0.2.8/rke_linux-amd64
# chmod +x rke_linux-amd64
# mv rke_linux-amd64 rke028
# vi cluster.yml
# set #kubernetes: rancher/hyperkube:v1.14.6-rancher1
# cp .kube/config kube_config_cluster.yml
# ./rke028 up


# Create cluster.yaml file
# rm -fv kube_config_cluster.yml
# cat cluster.yml.template > cluster.yml
# for NODE in ${NODES}; do
#	[[ "${NODE}" =~ "rke" ]] && sed -i -e "s/${NODE}/$(lxc exec ${NODE} -- bash -c 'ip -4 addr show eth0 | grep -oP "(?<=inet ).*(?=/)"')/" cluster.yml
# done

# Deploy Kubernetes cluster with rke
# rke up

# Install rancher on rancher node
# lxc exec rancher -- docker run -d --restart=unless-stopped -p 80:80 -p 443:443 rancher/rancher

# Open rancher webui
# echo     $(lxc exec rancher -- ip -4 addr show eth0 | grep -oP "(?<=inet ).*(?=/)" )
# xdg-open https://$(lxc exec rancher -- ip -4 addr show eth0 | grep -oP "(?<=inet ).*(?=/)" )
