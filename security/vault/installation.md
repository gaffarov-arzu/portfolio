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
# podlara baxaq
```bash
kubectl get pods -n vault
```
# initialize etmek
```bash
kubectl exec -n vault vault-0 -- vault operator init \
  -key-shares=5 \
  -key-threshold=3
```
