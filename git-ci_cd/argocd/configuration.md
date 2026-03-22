# installation on k8s
## evvelce ns yaradiriq
```bash
kubectl create namespace argocd

```
## sonra install
```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
## podlarin running olmasini yoxlayiriq
```bash
kubectl get pods -n argocd
```
