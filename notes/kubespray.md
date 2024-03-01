# Kubespray

```bash
git clone https://github.com/kubernetes-sigs/kubespray.git
git checkout tags/v<latest_version>

cd kubespray
VENVDIR=kubespray-venv
KUBESPRAYDIR=kubespray
python -m venv $VENVDIR
source $VENVDIR/bin/activate
pip install -U -r requirements.txt

# Copy ``inventory/sample`` as ``inventory/mycluster``
cp -rfp inventory/sample inventory/mycluster

# Update Ansible inventory file with inventory builder
declare -a IPS=(192.168.1.201 192.168.1.202 192.168.1.203 192.168.1.211 192.168.1.212)
CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}

# Review and change parameters under ``inventory/mycluster/group_vars``
cat inventory/mycluster/group_vars/all/all.yml
cat inventory/mycluster/group_vars/k8s_cluster/k8s-cluster.yml

# Clean up old Kubernetes cluster with Ansible Playbook - run the playbook as root
# The option `--become` is required, as for example cleaning up SSL keys in /etc/,
# uninstalling old packages and interacting with various systemd daemons.
# Without --become the playbook will fail to run!
# And be mind it will remove the current kubernetes cluster (if it's running)!
ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root reset.yml

ansible-playbook -i inventory/pve01/hosts.yaml -e @inventory/pve01/cluster-variable.yaml --become --become-user=root -u ubuntu --key-file ~/.ssh/wickes-homelab cluster.yml
wickes-homelab      wickes-homelab.pub

# Deploy Kubespray with Ansible Playbook - run the playbook as root
# The option `--become` is required, as for example writing SSL keys in /etc/,
# installing packages and interacting with various systemd daemons.
# Without --become the playbook will fail to run!
ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root cluster.yml
```
