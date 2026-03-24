# liveness ve ya ya readiness fail olsa da poda girmek olur amma restart geidr lakin eyni adda pod yaranir
# check etmek 
```bash
wget -qO- http://localhost:3000/api/health/live
wget -qO- http://localhost:3000/api/health/ready
```
