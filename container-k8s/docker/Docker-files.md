# simple nodejs
```dockerfile
#minimal linux - alpine  20- ise lts(long-term-support) dir
FROM node:20-alpine
#app adinda directory yarat ve ora gir
WORKDIR /app 
#repositorideki package.jsonu ./oldugun yere kopyala
COPY package*.json ./  
# dev dependenciler yuklenmesin deye
RUN npm install --omit=dev 
#proyektdeki herseyi containere kopyalayir, amma node_modules(npm install ile qurulub zaten) ve .env(sifreler, tokenler, api keyler - security cehetden) .git (lazimsizdir) *.log (lazimsiz)  kopyalamamaq ucun .docker ignore yazilir bunlar
COPY . . 
EXPOSE 3000 
 # index.js faylini islet

CMD ["node", "index.js"]
```
# mvn
#build stage burada 21 java versiyasi ucun image istifade olunur
#jdk javani jara cevirendir
#jre ise run environmentdir javani isletmek ucun
FROM maven:3.9-eclipse-temurin-21 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
#asagidaki kommanda proyekti build edir jar hazrilayir 
RUN mvn package -DskipTests

# ikinci stage
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
```
