# installation on k8s
## evvelce ns yaradiriq
```bash
kubectl create namespace argocd

```
## sonra install
```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
## podlarin running olmasini yoxlayiriq
```bash
kubectl get pods -n argocd
```
## passwordunu aliriq
```bash
 kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
9Y3RzDZRZnkuWO4A
```
## hostname yaradib ingress veririk
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd
  namespace: argocd
  annotations:
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
spec:
  ingressClassName: public
  rules:
    - host: argocd.musluck.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: argocd-server
                port:
                  number: 443
```
## oz sertifikatimizi qoymaq ucun cert manager yoxlanilir
```bash
kubectl get pods -n cert-manager
```
## yoxdursa qurasdirilir
```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/latest/download/cert-manager.yaml
```
## qurasdirildigi yoxlanilir
```bash
 kubectl get pods -n cert-manager -w
```
## cluster issuer yaradiriq
```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: your@email.com
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
      - http01:
          ingress:
            ingressClassName: public
```
## daha sonra ingresi yenileyirik
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd
  namespace: argocd
  annotations:
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
    nginx.ingress.kubernetes.io/ssl-redirect: "false"

spec:
  ingressClassName: public
  tls:
    - hosts:
        - argocd.musluck.com
      secretName: argocd-tls
  rules:
    - host: argocd.musluck.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: argocd-server
                port:
                  number: 443
```
## ve ya oz crt ve keyimizi istifade edirik
```bash
 kubectl create secret tls argocd-tls --cert=tls.crt --key=tls.key -n argocd
```
## ingressden ise letsencrypti qaldirirq
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd
  namespace: argocd
  annotations:
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
    nginx.ingress.kubernetes.io/ssl-redirect: "false"

spec:
  ingressClassName: public
  tls:
    - hosts:
        - argocd.musluck.com
      secretName: argocd-tls
  rules:
    - host: argocd.musluck.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: argocd-server
                port:
                  number: 443
```
