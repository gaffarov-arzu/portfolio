# sonarqube installasioasi
## helm repo elave edilir
```bash
helm repo add sonarqube https://SonarSource.github.io/helm-chart-sonarqube
helm repo update

```
## namespace yaradiriq
```bash
kubectl create namespace sonarqube
```
## install edirik
```bash
helm install sonarqube sonarqube/sonarqube \
  --namespace sonarqube \
  --set monitoringPasscode="myPasscode123" \
  --set community.enabled=true
```
## podun hazir olub olmamasini yoxlayiriq
```bash
kubectl get pods -n sonarqube
```
## ingress veririk
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: sonarqube-ingress
  namespace: sonarqube
spec:
  rules:
    - host: sonar.musluck.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: sonarqube-sonarqube
                port:
                  number: 9000
```
## login password admin/admin 
