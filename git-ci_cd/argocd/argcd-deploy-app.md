# repo k8s directorisinde deployment.yaml, service.yaml, ingress.yaml faylarini elave edirik
## argocd-app.yaml yaradib apply  edirik
```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: nextjs-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/gaffarov-arzu/nextjs-app
    targetRevision: main
    path: k8s
  destination:
    server: https://kubernetes.default.svc
    namespace: musluck
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```
