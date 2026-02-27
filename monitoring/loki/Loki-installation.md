# Loki installizasyasi ucun yaml
## vim prom-values.yaml
prometheus:
  prometheusSpec:
    securityContext:
      runAsUser: 0
      runAsGroup: 0
      fsGroup: 0
      runAsNonRoot: false

    initContainers:
      - name: init-chown-data
        image: busybox:latest
        command: ["chown", "-R", "1000:2000", "/prometheus"]
        volumeMounts:
          - name: prometheus-prometheus-kube-prometheus-prometheus-db
            mountPath: /prometheus

    storageSpec:
      volumeClaimTemplate:
        spec:
          storageClassName: "huawei-sc"
          accessModes: ["ReadWriteOnce"]
          resources:
            requests:
              storage: 50Gi
## Helm komandasi
```bash
helm upgrade prometheus prometheus-community/kube-prometheus-stack -n monitoring -f prom-values.yaml
```
