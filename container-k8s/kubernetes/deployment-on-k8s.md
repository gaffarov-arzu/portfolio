# namespace yaradiriq
```bash
kubectl create ns musluck
```
# registryden image ceke bilmek ucun secret yaradilmali
```bash
kubectl create secret docker-registry ghcr-secret --namespace musluck --docker-server=ghcr.io --docker-username=gaffarov-arzu --docker-password=ghp_xxxxxxxxxxxxxxxxx
```
# deployment faylini yaradiriq
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nextjs-app
  namespace: musluck
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nextjs-app
  template:
    metadata:
      labels:
        app: nextjs-app
    spec:
      imagePullSecrets:
        - name: ghcr-secret
      containers:
        - name: nextjs-app
          image: ghcr.io/gaffarov-arzu/nextjs-app:latest
          ports:
            - containerPort: 3002
```
# image pullbackoff xetasi cixsa (image tapa bilmeye biler)
```bash
kubectl describe pod -n musluck nextjs-app-54474c7986-hzlbc
```
# sonra ya yamlda deyisirik ya da set ile
```bash
kubectl set image deployment/nextjs-app nextjs-app=ghcr.io/musluck-com/nextjs-app:latest -n musluck
```
# imagepullbackoff diger iki sebebdende ola biler auth xetasi ya da registrye ile elaqe qura bilmemekden

# sonra servisini yaradiriq
```yaml
apiVersion: v1
kind: Service
metadata:
  name: nextjs-app
  namespace: musluck
spec:
  selector:
    app: nextjs-app
  ports:
    - port: 3002
      targetPort: 3002
```
# sonra ingress yaziriq
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nextjs-app
  namespace: musluck
spec:
  rules:
    - host: dev.musluck.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: nextjs-app
                port:
                  number: 3002
```
# ingressde problem olsa ingress podlarina baxilir
```bash
 kubectl get pods -n ingress
```
