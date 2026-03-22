# evvelce helm ile qurmaq ucun helm quraq
```bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```
# sonra vault reposunu elave edek
```bash
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update
```

# vaultu qurmaq
```bash
helm install vault hashicorp/vault \
  --namespace vault \
  --create-namespace \
  --set server.dev.enabled=false
```
# problem cixa biler helm kubeconfigi gormeye biler ona gore
```bash
microk8s config > ~/.kube/config
```
# podlara baxaq
```bash
kubectl get pods -n vault
```
# initialize etmek
```bash
kubectl exec -n vault vault-0 -- vault operator init \
  -key-shares=5 \
  -key-threshold=3
```
# initialize edende bize unseal ve root token verir 3 denesini istfade edeceyik
```bash
kubectl exec -n vault vault-0 -- vault operator unseal LOeh+A7Tj+VZejRGBEl15oIYfG/i6OJiXeteGugIL+6I
kubectl exec -n vault vault-0 -- vault operator unseal AKzTUOqt29IJq7WFvs/aDg21VZc5Qht11LGWW8dXgDJY
kubectl exec -n vault vault-0 -- vault operator unseal wBEekVcVnRYxBSTrvfh+tqji8elfDRFKAxmpUWBMgbNQ
```
# podlar running olmalidi
```bash
kubectl get pods -n vault
```
# vault ucun ingress quraq
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: vault
  namespace: vault
  annotations:
    nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
spec:
  ingressClassName: public
  rules:
    - host: vault.musluck.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: vault
                port:
                  number: 8200
```
# uidan login oluruq root token istifade ederek
# kubernetesin vaultdan nese oxuya bilmesi ucun kubernetes auth method elave edirik bunu authentication method hissesine girib kubernetesi elave ederek ede bilerik uidan
# sonra hansi application oxusun deye policy yaradiriq
```json
path "musluck/data/api-gateway" {
  capabilities = ["read"]
}
```
# sonra uidan role yaradiriq
- adi
- service account name
- namespace
- generated token policy
# sonra kuberneteste service account yaradiriq
```bash
kubectl create serviceaccount api-gateway -n musluck
```
# podun vaultu oxumasi ucun external-secret istifde deceyik
## qurulmasi
```bash
helm repo add external-secrets https://charts.external-secrets.io
helm repo update
helm install external-secrets external-secrets/external-secrets \
  --namespace external-secrets \
  --create-namespace
```
## cluster secret store qurasdirilmasi
```yaml

apiVersion: external-secrets.io/v1
kind: ClusterSecretStore
metadata:
  name: vault-backend
spec:
  provider:
    vault:
      server: "http://vault.vault.svc:8200"
      path: "musluck"
      version: "v2"
      auth:
        kubernetes:
          mountPath: "kubernetes"
          role: "api-gateway"
          serviceAccountRef:
            name: "api-gateway"
            namespace: "musluck"
```
## appy edenden sonra yoxlayiriq
```bash
kubectl get clustersecretstore vault-backend
```
## ClusterSecretStore vaultun addresi, External Secret (storeun aid verilir) vaultdaki hansi pathdan secreti alacagi, sonra ise secret avtomatik yaradilir
