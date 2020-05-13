#!/bin/bash
mkdir -p /home/ubuntu/.config/lxc/
sudo chown -R ubuntu:ubuntu /home/ubuntu/.config
lxd init --preseed < lxd-init.yaml
#sudo lxc delete rke1 rke2 rke3 --force
NODES=$(echo rke{1..3})
ssh-keygen -b 2048 -t rsa -f /home/ubuntu/.ssh/id_rsa -q -N ""
SSH_PUBKEY="/home/ubuntu/.ssh/id_rsa.pub"

LXC_IMAGE="ubuntu:focal"
sudo lxc profile edit default < lxc-profile-default.yaml
sudo lxc profile create docker
sudo lxc profile edit docker < lxc-profile-docker.yaml
LXC_PROFILES="--profile default --profile docker"

# Create containers
for NODE in ${NODES}; do lxc launch ${LXC_PROFILES} ${LXC_IMAGE} ${NODE} ; done

# Wait a few seconds for nodes to be up
sleep 20

# Push ssh keys
for NODE in ${NODES}; do lxc file push ${SSH_PUBKEY} ${NODE}/home/ubuntu/.ssh/authorized_keys --mode 0700 ; done

# Install Docker
for NODE in ${NODES}; do
	# lxc exec ${NODE} -- bash -c 'curl -L get.docker.com | bash'
        # lxc exec ${NODE} -- bash -c 'curl https://releases.rancher.com/install-docker/18.06.sh | sh'
	# don't use docker 19.03 for now, it doesn't work at least on lxc
	lxc exec ${NODE} -- bash -c 'sudo apt install docker.io -y'
	# Add ubuntu user to docker group
	lxc exec ${NODE} -- sudo usermod -aG docker ubuntu
	# Workaround bug (for lxc ???)
	lxc exec ${NODE} -- mkdir -p /etc/systemd/system/docker.service.d
	#lxc file push -v <(echo -e '[Service]\nMountFlags=shared') ${NODE}/etc/systemd/system/docker.service.d/override.conf
	lxc file push docker-shared ${NODE}/etc/systemd/system/docker.service.d/override.conf
	lxc exec ${NODE} -- systemctl enable --now docker
	lxc exec ${NODE} -- systemctl restart docker.service

	# Print installed version
	lxc exec ${NODE} -- docker --version
done

# Print nodes ip addresses
for NODE in ${NODES}; do
	lxc exec ${NODE} -- bash -c 'echo -n "$(hostname) " ; ip -4 addr show eth0 | grep -oP "(?<=inet ).*(?=/)"'
done
echo "lxc containers installed:"
sudo lxc ls

echo "adapt your /etc/hosts file somehow like this"
echo "10.208.85.34 rke1"
echo "10.208.85.91 rke2"
echo "10.208.85.4  rke3"
echo "and run ./deploy-rke.sh"
