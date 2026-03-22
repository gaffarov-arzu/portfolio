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

## Oz crt ve keyimizi istifade edirik
```bash
 kubectl create secret tls argocd-tls --cert=tls.crt --key=tls.key -n argocd
```
## ingressden ise letsencrypti qaldirirq portu 80 edirik backend protocolu ise http edirik
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd
  namespace: argocd
  annotations:
    nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
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
                  number: 80
```
## errorlar cixarsa svc ve ingressi logl ve describe edirik
```bash
kubectl get svc argocd-server -n argocd
kubectl describe ingress argocd -n argocd
kubectl logs -n ingress nginx-ingress-microk8s-controller-vcvx5 | tail -20
```
