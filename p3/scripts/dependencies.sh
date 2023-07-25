sudo apt-get install ca-certificates curl gnupg lsb-release
if which kubectl > /dev/null ; then
	echo "[INFO] KUBECTL ALREADY INSTALLED"
else
	echo "[INFO] INSTALLING KUBECTL"
	curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg &&
	echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list &&
	sudo apt-get update &&
	sudo apt-get install -y kubectl
	echo "[INFO] KUBECTL INSTALLED"
fi

if which docker > /dev/null
then
	echo "[INFO] DOCKER ALREADY INSTALLED"
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
	echo "[INFO] K3D ALREADY INSTALLED"
else
	echo "[INFO] INSTALLING K3D"
	curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
	echo "[INFO] K3D INSTALLED"
fi
