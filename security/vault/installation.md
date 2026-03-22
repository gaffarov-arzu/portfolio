# evvelce helm ile qurmaq ucun helm quraq
```bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```
# sonra vault reposunu elave edek
```bash
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update
```

# vaultu qurmaq
```bash
helm install vault hashicorp/vault \
  --namespace vault \
  --create-namespace \
  --set server.dev.enabled=false
```
# problem cixa biler helm kubeconfigi gormeye biler ona gore
```bash
microk8s config > ~/.kube/config
```
