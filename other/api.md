# api sorgusu ne qeder cekir test etmek
```bash
curl -o /dev/null -s -w "%{time_total}s\n" https://api.musluck.com/api/areas
```

# 1000 eded sorgu gondermek
```bash
ab -n 1000 -c 50 https://api.musluck.com/api/areas
```
# token almaq
```bash
curl -X POST https://api.musluck.com/api/login \
  -H "Content-Type: application/json" \
  -d '{"username":"testtest","password":"senin_sifren"}'
```
1. Belirli bir endpoint'i test et:
bashcurl -X GET https://api.musluck.com/api/areas \
  -H "Authorization: Bearer TOKEN"
2. POST isteği gönder:
bashcurl -X POST https://api.musluck.com/api/login \
  -H "Content-Type: application/json" \
  -d '{"username":"test","password":"123456"}'
3. Yük testi — 1000 kullanıcı aynı anda:
bashab -n 1000 -c 100 -H "Authorization: Bearer TOKEN" \
  https://api.musluck.com/api/areas
4. Canlı logları izle — sorgu gelince ne oluyor gör:
bashtail -f /var/log/nginx/musluck.access.log
5. Backend loglarını izle:
bashpm2 logs

# pm2 isleyen backendlerin siyahisi
```bash
pm2 list
```
