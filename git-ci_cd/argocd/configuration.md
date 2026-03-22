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
