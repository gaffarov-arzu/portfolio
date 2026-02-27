# helm chartda neyise deyisenden sonra asagidaki komanda ile upgrade edilir
```bash
  helm upgrade loki grafana/loki-stack -n monitoring -f loki-values.yaml
```

# helm chart silmek
```bash
helm uninstall loki -n monitoring
```

# helm neyise install etmek
```bash
helm install loki grafana/loki-stack -n monitoring -f loki-values.yaml
```
# helm repo elave elemek
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
```
# helm repo update(vacib deyil repodd deyisiklik olsa etmek olar)
```bash
helm repo list
helm repo remove
```
# helm chart axtarmaq
```bash
helm search repo nginx
helm search hub nginx (globalda axtarmaq)
nginx charti install etmek 
helm install nginx-test bitnami/nginx
```
# yuklenen relaselari gormekcun
```bash
helm list -A
```
# releasi silmek ucun
```bash
helm uninstall nginx-test
```
# helm chart statusuna baxmaq 
```bash
helm status nginx-test
```
# helm listi upgrade elemek ucun my-values.yaml yaradili(yalniz release varsa eger yoxsa install lazim)
```bash
helm upgrade my-nginx bitnami/nginx -f my-values.yaml
```

# helm history yazib revisayalara baxib istediyimiz revizyaya qayitmaq ucun
```bash
 helm rollback my-nginx 1
```
