install i:
	ansible-playbook -i hosts.conf install-kubernetes.yml -kK


master m:
	ansible-playbook -i hosts.conf kube-master.yml -kK


worker w:
	ansible-playbook -i hosts.conf kube-worker.yml -kK