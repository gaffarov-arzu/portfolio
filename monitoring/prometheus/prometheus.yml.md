# yaml fayli sintaksisi
## scrape interval metriklerden nece saniyede bir metrik toplamasini gosterir
## rule_files burada alert rule yazilir 

```yaml
global:
 scrape_interval: 15s
rule_files:
  - /etc/prometheus/rules/vm-alert-rules.yaml
scrape_configs:
  - job_name: 'jaeger'
    static_configs:
      - targets: ['x.x.x.x:14269']
```
