# Prometheus-grafana kubernetese helm ile install olunmasi 
##  helm reposu elave edilir
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```
## namespace yaradiriq
```bash
kubectl create ns monitoring
```
## install edirik
```bash
helm install monitoring prometheus-community/kube-prometheus-stack -n monitoring
```
## ingresle kenara cixaririq hem prometheusu hem de grafanani
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: grafana-ingress
  namespace: monitoring
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - host: grafana.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: monitoring-grafana
            port:
              number: 80
```
### eger microk8s de problem olsa
```bash
helm upgrade monitoring prometheus-community/kube-prometheus-stack -n monitoring   --set grafana.sidecar.skipTlsVerify=true
```
