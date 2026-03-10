# kubernetese redis yazilmasi
## bintami reposunun elave edilmesi
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
```
## redisin yazilmasi
```bash
helm install redis bitnami/redis \
  --namespace redis-ns \
  --set auth.enabled=true \
  --set auth.password=strongpassword \
  --set persistence.enabled=true \
  --set persistence.size=8Gi
redis install
```
## redisin passworduna baxmaq
```bash
kubectl get secret redis -n megasec-face-dev -o jsonpath="{.data.redis-password}" | base64 -d
```
## redis password deyismek
```bash
helm upgrade redis bitnami/redis -n megasec-face-dev --set auth.password=StrongPass123

```
### rediste connection yoxlamaq
```bash
redis-cli -u redis://healthcheck_f5:password@fdrs-redis.xxx.xxx.az:6379 ping
```
### redis-cli ile yoxlamaq
```bash
sudo apt install redis-tools -y
```
## redisi nodeport la yazmaq
```bash
helm install redis bitnami/redis \
  --namespace mm-dev \
  --set auth.enabled=true \
  --set auth.password='Pe0\Ya89(A%8' \
  --set persistence.enabled=true \
  --set persistence.size=8Gi \
  --set persistence.storageClass=longhorn \
  --set service.type=NodePort \
  --set service.nodePort=32073
```
## connection yoxlamaq
```bash
REDISCLI_AUTH="Pe0Ya89(A%8" redis-cli -h x.x.x.x -p 32073 ping
```
## redise qosulmaq
```bash
REDISCLI_AUTH="Pe0Ya89(A%8" redis-cli -h x.x.x.x -p 30366
```
## redis user yaratmaq
```redis
ACL SETUSER appuser on >StrongPass123 allcommands allkeys
```
## redisde userlere baxmaq
```redis
ACL LIST
```
## redis-insight-deploymenti
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redisinsight
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redisinsight
  template:
    metadata:
      labels:
        app: redisinsight
    spec:
      containers:
      - name: redisinsight
        image: redislabs/redisinsight:latest
        ports:
        - containerPort: 8001
        resources:
          limits:
            memory: "512Mi"
            cpu: "500m"
```
## redis-insight servisi
```yaml
apiVersion: v1
kind: Service
metadata:
  name: redisinsight-service
spec:
  type: NodePort   
  selector:
    app: redisinsight
  ports:
    - protocol: TCP
      port: 8001
      targetPort: 8001
      nodePort: 30001  
```
