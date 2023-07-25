# argocd deploy: https://www.youtube.com/watch?v=2oWtBDOJgUM

sudo k3d cluster create argocd 
sudo kubectl config use-context k3d-argocd
sudo kubectl create namespace argocd
sudo kubectl config use-context k3d-argocd
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

while [[ $(sudo kubectl get pods -n argocd | grep Running | wc -l) != '7' ]]
do
	echo "WAITING FOR ARGOCD... ($(sudo kubectl get pods -n argocd | grep Running | wc -l) / 7)" && sleep 10
done

echo "PASSWORD --> $(sudo kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d)" &&
sudo kubectl port-forward svc/argocd-server -n argocd 8080:443
