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
