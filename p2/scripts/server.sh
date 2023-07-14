#!/bin/sh

mkdir /confs/app1 /confs/app2 /confs/app3
sed 's/>>APP_VERSION<</app1/' /confs/index.html > /confs/app1/index.html
sed 's/>>APP_VERSION<</app2/' /confs/index.html > /confs/app2/index.html
sed 's/>>APP_VERSION<</app3/' /confs/index.html > /confs/app3/index.html

curl -sfL https://get.k3s.io |
	SERVER_IP="192.168.56.110" \
	INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --tls-san $(hostname) --node-ip $SERVER_IP --bind-address=$SERVER_IP --advertise-address=$SERVER_IP" \
	sh -

sleep 10

# https://www.jeffgeerling.com/blog/2022/quick-hello-world-http-deployment-testing-k3s-and-traefik

/usr/local/bin/kubectl create configmap app1-file --from-file /confs/app1
/usr/local/bin/kubectl create configmap app2-file --from-file /confs/app2
/usr/local/bin/kubectl create configmap app3-file --from-file /confs/app3

kubectl apply -f /confs/services.yaml
sleep 10
kubectl apply -f /confs/deploy.yaml
sleep 10
kubectl apply -f /confs/ingress.yaml
