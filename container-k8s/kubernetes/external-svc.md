# kubernetes ingresi ile kllusterdan kenardaki bir servisi serve etmek
## evvelce service ve endpoint  yaradiriq port servisin portun target ise kenardaki ipe qosulmaq ucun lazim olan portdur

```yaml
apiVersion: v1
kind: Service
metadata:
  name: external-backend
spec:
  ports:
    - port: 80
      targetPort: 9000
---
apiVersion: v1
kind: Endpoints
metadata:
  name: external-backend
subsets:
  - addresses:
    - ip: 10.0.0.4
    ports:
      - port: 9000
```
# o servisi ingress ile expose etmek
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: external-ingress
spec:
  rules:
    - host: myapp.local
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: external-backend
                port:
                  number: 80
```
