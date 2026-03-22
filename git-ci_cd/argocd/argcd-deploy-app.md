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
    repoURL: https://github.com/musluck-com/musluck.com-front-nextjs
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
## sync olmaya biler ona gore argo uid de settings repository connect repo edib repo url ni veririk, orada https secirik github user ve password veririk sonra sync
##
