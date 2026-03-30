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
```dockerfile
#build stage burada 21 java versiyasi ucun image istifade olunur
#jdk javani jara cevirendir
#jre ise run environmentdir javani isletmek ucun
FROM maven:3.9-eclipse-temurin-21 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
#asagidaki kommanda proyekti build edir jar hazrilayir 
RUN mvn package -DskipTests

## ikinci stage
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
```
# typescript
```dockerfile
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --only=production
COPY --from=builder /app/dist ./dist
EXPOSE 4001
CMD ["node", "dist/main.js"]
```
# python
```dockerfile

  FROM   python:3.12-slim

  WORKDIR /app

  COPY requirements.txt .
  RUN pip install --no-cache-dir -r requirements.txt

  COPY . .
#test
  EXPOSE 4004

  CMD ["python", "main.py"]
```
# gradle
```dockerfile
FROM gradle:8.7-jdk17 AS build
WORKDIR /app
COPY . .
# jar fayli build etmek(gradle build ile murekkeb olardi bizim halimizda)
RUN gradle bootJAR --no-daemon

FROM eclipse-temurin:17-jdk-focal
WORKDIR /app

COPY --from=build /app/build/libs/*.jar app.jar
#asagidaki o demekdir ki jar fayli islet class yox hersey bir jarin icindedir
ENTRYPOINT ["java", "-jar", "app.jar"]
```
# nextjs
```dockerfile
#asagida as o demekdir ki bu hisse novbeti stagelerde istifade olunacaq
FROM node:20-alpine AS deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci

FROM node:20-alpine AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=3002
ENV HOSTNAME="0.0.0.0"
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

COPY --from=builder /app/public ./public
#COPY --from=builder /app/.next ./.next
#COPY --from=builder /app/node_modules ./node_modules
#COPY --from=builder /app/package.json ./package.json

EXPOSE 3002
CMD ["node", "server.js"]
```
