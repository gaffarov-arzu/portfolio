## install edilmesi
```bash
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install loki grafana/loki-stack -n monitoring
```
## ingrese cixarmaq ucun servisi tapiriq
```bash
kubectl get svc -n monitoring | grep loki
```
