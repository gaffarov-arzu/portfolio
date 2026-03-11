# En cox edilen 5 deployment novu
## recreate deployment(az istifade olunur downtime var)
- burada kohne deployment tamamile dayandirilir yenisi yaradilir ona kecilir
## rolling update
- meselen 4 podun varsa update gedende bir pod yaranir sonra onun evez edeceyi pod terminate olur sonra yeni pod yaranir ikinci pod terminate olur
- biz strategiya quraraq faizle vere bilerik meselen 25 faizi dayansin meselen 4 pod varsa bir bir getsin kimi,
## blue green deployment
- meselen kohne yerinde qalir yenisi yaradilir test edilir qaydasindadirsa kohne sondurulur yeniye kecilir
- db terefde problem ola biler iki ferqli db
## canary
- meselen deployment yaradilir bir label ile amma replicasi coxdur basqa bir dene de deployment yaradilir replicasi az servis qurulub selector ile, ve bolusturub gonderir
