# argocd deploy: https://www.youtube.com/watch?v=2oWtBDOJgUM

sudo k3d cluster create argocd -p "8888:8888@loadbalancer"
sudo kubectl config use-context k3d-argocd
sudo kubectl create namespace argocd &&
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

while [[ $(sudo kubectl get pods -n argocd 2> /dev/null | grep Running | wc -l) != '7' ]]
do
	echo "WAITING FOR ARGOCD... ($(sudo kubectl get pods -n argocd 2> /dev/null | grep Running | wc -l) / 7)" && sleep 10
done

sudo kubectl create namespace dev &&
sudo kubectl apply -f $(dirname "$0")/../confs/app.yaml

while [[ $(sudo kubectl get pods -n dev 2> /dev/null 2> /dev/null | grep Running | wc -l) != '1' ]]
do
	echo "WAITING FOR APP... ($(sudo kubectl get pods -n dev 2> /dev/null | grep Running | wc -l) / 1)" && sleep 10
done

echo "--- ARGOCD -------------------" &&
echo "LOGIN --> admin" &&
echo "PASSWORD --> $(sudo kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d)"
echo "------------------------------" &&
sudo kubectl port-forward svc/argocd-server -n argocd 8080:443 > /dev/null &

sudo kubectl create namespace gitlab
sudo helm repo add gitlab https://charts.gitlab.io/ &&
sudo helm repo update
sudo helm upgrade --install gitlab gitlab/gitlab \
  --timeout 600s \
  --set global.hosts.domain=alemarch.com \
  --set global.hosts.externalIP=$(hostname -I | awk '{ print $1 }') \
  --set certmanager-issuer.email=alemarch@student.42.com \
  --set postgresql.image.tag=13.6.0 \
  --namespace gitlab

echo "--- GITLAB -------------------" &&
echo "PASSWORD --> $(sudo kubectl get secret gitlab-gitlab-initial-root-password -o jsonpath='{.data.password}' | base64 --decode)"
echo "------------------------------"
sudo kubectl port-forward svc/gitlab-webservice-default -n gitlab 8181:8181
