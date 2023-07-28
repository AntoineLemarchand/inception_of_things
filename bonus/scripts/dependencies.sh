sudo apt-get install ca-certificates curl gnupg lsb-release
if which kubectl > /dev/null ; then
	echo "KUBECTL ALREADY INSTALLED"
else
	echo "INSTALLING KUBECTL"
	curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg &&
	echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list &&
	sudo apt-get update &&
	sudo apt-get install -y kubectl
	echo "KUBECTL INSTALLED"
fi

if which docker > /dev/null
then
	echo "DOCKER ALREADY INSTALLED"
else
	if [ lscpu | grep VT-x != 0 ] ; then
		echo "[WARNING] KVM NOT ACTIVATED"
		exit 1
	fi
	sudo mkdir -p /etc/apt/keyrings && 
	 curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg && 
	echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && 
	sudo apt update && 
	sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
fi
if which k3d > /dev/null
then
	echo "K3D ALREADY INSTALLED"
else
	echo "INSTALLING K3D"
	curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
	echo "K3D INSTALLED"
fi

if which helm > /dev/null
then
	echo "HELM ALREADY INSTALLED"
else
	echo "INSTALLING HELM"
	curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
	sudo apt-get install apt-transport-https --yes
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
	sudo apt-get update
	sudo apt-get install helm
	echo "HELM INSTALLED"
fi
