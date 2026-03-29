# autoscaling ucun metric server islemesi lazimdir
# hpa yaml yazilir
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: api-app-hpa
  namespace: musluck
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: api-app
  minReplicas: 1
  maxReplicas: 5
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
```
# varligi test edilir
```bash
kubectl get hpa -n musluck
```
# hesablama bele isleyir deployment yaml faylinda request var 200m onun 70 faizina catanda hpa trigger olur
```yaml
          resources: 
            requests:
              cpu: "200m"
              memory: "256Mi"
```
# podun icine giririk
```bash
while true; do :; done &
while true; do :; done &
while true; do :; done &
```
# bunlari dayandirmaq ucun j
```bash
jobs
kill %1 %2 %3
```
