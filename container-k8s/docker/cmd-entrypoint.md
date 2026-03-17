# Entrypoint odur ki  container her baslayanda commandani avtomatik islet 
# run image yaradilanda istifade edilir
# cmd ise container baslayanda istifade olunur amma override edile bilinir
## meselen asagidaki commanda deyisile bilinir
```dockerfile
CDM ["java", "-jar", "app.jar"]
```
## yuxaridaki container baslayanda isleyir amma deyisile biliner asagidaki kimi
```bash
docker run myapp java -jar other.jar
```
