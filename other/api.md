# api sorgusu ne qeder cekir test etmek
curl -o /dev/null -s -w "%{time_total}s\n" https://api.musluck.com/api/areas
