# hansi docker registirisine login oldugunu yoxlamaq
```bash
cat ~/.docker/config.json
```
# docker logout olmaq
```bash
docker logout
```
# docker file dan image build etmek
```bash
docker build -t qafarzu/my-app:latest .
```
# dockerfile oldugu yerde coxlu fayllar ola biler onlari ignore etmek ucun .dockerignore faylina asagidakini yazib sadece lazimli olanlari gonderirik
```bash
*
!paraschute.html
```
