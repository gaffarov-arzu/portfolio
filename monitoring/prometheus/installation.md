# Prometheus-grafana kubernetese helm ile install olunmasi 
## Prometheus stack install olunmasi ucun bu yaml istifade edirik
```yaml
#prom-values.yaml
loki:
  persistence:
    enabled: true
    storageClassName: "huawei-sc"
    size: 50Gi

  securityContext:
    fsGroup: 0
    runAsGroup: 0
    runAsUser: 0
    runAsNonRoot: false
  config:
    common:
      path_prefix: /data
      storage:
        filesystem:
          chunks_directory: /data/chunks
          rules_directory: /data/rules
      replication_factor: 1
      ring:
        instance_addr: 127.0.0.1
        kvstore:
          store: inmemory
    storage_config:
      boltdb_shipper:
        active_index_directory: /data/index
        cache_location: /data/index_cache
        resync_interval: 5s
promtail:
  enabled: true
```
## Helm kommandasi 
```bash
helm install loki grafana/loki-stack -n monitoring -f loki-values.yaml
```

