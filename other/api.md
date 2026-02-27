# api sorgusu ne qeder cekir test etmek
```bash
curl -o /dev/null -s -w "%{time_total}s\n" https://api.musluck.com/api/areas
```

# 1000 eded sorgu gondermek
```bash
ab -n 1000 -c 50 https://api.musluck.com/api/areas
```
