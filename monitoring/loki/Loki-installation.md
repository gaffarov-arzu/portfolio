# install edilmesi
```bash
#loki-values.yaml
# loki-values.yaml
loki:
  commonConfig:
    replication_factor: 1
  storage:
    type: filesystem
  auth_enabled: false

deploymentMode: SingleBinary

singleBinary:
  replicas: 1
  persistence:
    enabled: true
    storageClass: huawei-sc
    size: 50Gi

monitoring:
  lokiCanary:
    enabled: false
  selfMonitoring:
    enabled: false
    grafanaAgent:
      installOperator: false

test:
  enabled: false

gateway:
  enabled: false
```
# 
