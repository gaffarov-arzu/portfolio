# crashloopbackoff - db -e baglana bilmeyende
## loglara baxmaq ucun
```bash
kubectl logs -n monitoring monitoring-grafana-787bb444c8-44ccg
```
## describe baxmaq
```bash
kubectl describe pod -n monitoring monitoring-grafana-787bb444c8-44ccg
```
## describede asagidaki problemler olur
### container hissesinde
- exit code 1 (config, env, permission)
- exitcode 137 (memory kill OOM)
- OOMKIlled - ram catmir
- copleted - entrypoint xetasi
### events hissesinde
- failedmount - pvc problemi
- backoff - crash
- failedscheduling - resur yoxdu
- unhealthy - readiness fail
