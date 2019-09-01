#!/bin/bash
kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
curl -LO https://git.io/get_helm.sh
sudo chmod 700 get_helm.sh
./get_helm.sh
helm init --service-account tiller
sleep 60
helm install stable/cert-manager --name cert-manager --namespace kube-system --version v0.5.2
sleep 60
kubectl -n kube-system rollout status deploy/cert-manager
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm install --name rancher rancher-latest/rancher --namespace cattle-system --set hostname=lxc.kubernauts.de --set ingress.tls.source=letsEncrypt --set letsEncrypt.email=devops@cloudssky.com
lxc config device add rke1 rancher443 proxy listen=tcp:0.0.0.0:443 connect=tcp:localhost:443
