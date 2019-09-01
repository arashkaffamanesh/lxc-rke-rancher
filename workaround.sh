#!/bin/bash
# sudo lxd init --preseed < lxd-init.yaml
NODES=$(echo rke{1..3})

# Install Docker
for NODE in ${NODES}; do
	# Workaround bug (for docker 17.03 ???)
	lxc exec ${NODE} -- mkdir -p /etc/systemd/system/docker.service.d
	lxc file push -v <(echo -e '[Service]\nMountFlags=shared') ${NODE}/etc/systemd/system/docker.service.d/override.conf
	lxc exec ${NODE} -- systemctl daemon-reload
	lxc exec ${NODE} -- systemctl restart docker.service

	# Print installed version
	lxc exec ${NODE} -- docker --version
done

# Print nodes ip addresses
for NODE in ${NODES}; do
	lxc exec ${NODE} -- bash -c 'echo -n "$(hostname) " ; ip -4 addr show eth0 | grep -oP "(?<=inet ).*(?=/)"'
done

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

