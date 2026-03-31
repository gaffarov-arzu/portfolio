# Prometheus-grafana kubernetese helm ile install olunmasi 
##  helm reposu elave edilir
```bash
helm repo list
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```
## chartlari listelemek
```bash
helm search repo prometheus
```
## xususi repo axtarmaq
```bash
helm search repo prometheus-community/kube-prometheus-stack
```
## versiyalarina baxmaq
```bash
 helm search repo prometheus-community/kube-prometheus-stack --versions
```
## namespace yaradiriq
```bash
kubectl create ns monitoring
```
## install edirik
```bash
helm install monitoring prometheus-community/kube-prometheus-stack -n monitoring
```
## istediyimiz versiyani install etmek ucun
```bash
helm install prometheus prometheus-community/kube-prometheus-stack --version 45.7.1 --namespace monitoring  --create-namespace
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
### eger microk8s de problem olsa - sidecarlar problem yarada biler
```bash
helm upgrade monitoring prometheus-community/kube-prometheus-stack -n monitoring   --set grafana.sidecar.skipTlsVerify=true
```
### grafana passwordunu almaq ucun
```bash
kubectl --namespace monitoring get secrets monitoring-grafana -o jsonpath="{.data.admin-password}" | base64 -d ; echo
```
## Yuxaridaki stack asagidakilari endirir
- prometheus
- node-exporter
- grafana
- kube-state-metric
