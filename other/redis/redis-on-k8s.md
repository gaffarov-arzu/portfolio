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
