
# Learning Github-cicd, Kubernetes, AWS, Terraform
# Gun-1-9

## 1. aws sts get-caller-identity

Göstərir:

UserId: AWS hesabındakı spesifik istifadəçi və ya rol

Account: AWS hesabının nömrəsi (bütün istifadəçilərdə eyni)

Arn: İstifadəçi və ya rolun tam identifikatoru

Nümunə:

```json
{
    "UserId": "AIDAVUGKZIAUBD4LPOS5W",
    "Account": "386972336168",
    "Arn": "arn:aws:iam::386972336168:user/arzu-admin"
}
```

IAM User → insanlar üçün, access key/secret key ilə giriş.

IAM Role → xidmətlər üçün, EC2, Lambda, GitHub Actions kimi.

EC2-nin S3 bucket-ə çıxışı üçün:

Policy yaradılır (S3 read/write və s.)

Role yaradılır və policy attach edilir

EC2 instance bu role ilə əlaqələndirilir → EC2 “Instance Profile” istifadə edir

## 2. EC2 və AMI

Hər EC2 öz AMI-sindən yaradılır → fərqli version, nvme disk və s. ola bilər.

AMI = “snapshot” + OS + configuration.

CI/CD Konsepsiyaları

Continuous Delivery vs Continuous Deployment

Delivery → deploy manual, kod hazır vəziyyətə gətirilir

Deployment → avtomatik deploy, yoxlama addımı olmadan

Artifact

CI/CD-də build nəticəsi (.jar, .war, .zip və s.)

GitHub Actions

Job → bir və ya bir neçə step-dən ibarət

Step → build/test/deploy əməliyyatları

Multi-job → jobs needs ilə sıralana bilər, əks halda parallel işləyir

MicroK8s və Kubernetes

## 1. MicroK8s quraşdırılması
```bash
snap install microk8s --classic
sudo usermod -a -G microk8s $USER
sudo chown -f -R $USER ~/.kube
newgrp microk8s
microk8s status --wait-ready
```

## 2. Pod YAML nümunəsi
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-demo
spec:
  containers:
    - name: nginx
      image: nginx:latest
      ports:
        - containerPort: 80
```

## 3. Deployment YAML nümunəsi
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
        - name: nginx
          image: nginx:latest
          ports:
            - containerPort: 80
```
## Terraform

1. S3 Bucket yaratmaq
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "benim-ilk-bucket-12345"
  acl    = "private"
}
```

Komandalar:
```bash
terraform init
terraform apply
```

## 2. EC2 yaratmaq
```hcl
provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0699c78c4486e5f1e"
  instance_type = "t2.micro"
}
```

Komandalar:
```bash
terraform plan
terraform apply
```

## 3. Terraform State

Local → kompüterdə saxlanılır

Remote → S3 bucket və DynamoDB ilə lock, multi-user üçün 

# Gun-10

Arn - amazon-resource-name
## 1)aws user yaratmaq
```bash
aws iam create-user --user-name test-user
```
## 2)user ucun access key yaratmaq
```bash
aws iam create-access-key --user-name test-user
```
## 3)usere policy attach etmek
```bash
aws iam attach-user-policy \
    --user-name test-user \
    --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess
```
## 4) iam policy-ni simulasya etmek
```bash
aws iam simulate-principal-policy \
    --policy-source-arn arn:aws:iam::386972336168:user/test-user \
    --action-names s3:ListBucket s3:PutObject \
    --resource-arns arn:aws:s3:::benim-ilk-bucket-12345/*
```
iam policy-ni simulasya etmek
### 5)s3-un accesini tapmaq ucun ise
```bash
aws iam simulate-principal-policy \
    --policy-source-arn arn:aws:iam::386972336168:role/EC2-S3-Access \
    --action-names s3:ListBucket s3:PutObject s3:GetObject \
    --resource-arns arn:aws:s3:::benim-ilk-bucket-12345/*
```
burada esas ferq roledur
# Gun-11
## 1)kubernetese label elave etmek 
```bash
microk8s kubectl label pod  nginx-demo app=web
```
## 2)service yaml
```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-svc
spec:
  type: NodePort
  selector:
    app: web
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30080
```
## 3)target port containerin portu, port ise servisin portu, servise gelen trafik containere yonlendirilir
# Gun-12

## 1)configmap yaml burada asagidaki variabellari podun icinde istifade ede bilerik, configmapin ve key hissesinin adini  yazaraq valuesini ise configmapdan goturecek
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  APP_ENV: "production"
  LOG_LEVEL: "info"
```
## 2)pod- config map istifadesi ucun
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-configmap-demo
spec:
  containers:
    - name: nginx
      image: nginx:latest
      env:
        - name: APP_ENV
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: APP_ENV
        - name: LOG_LEVEL
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: LOG_LEVEL
```
# Gun-13
## secret yaratmaq ve secreti poda vermek
1)secret.yaml
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
type: Opaque
data:
  DB_USER: YWRtaW4=        # admin (base64 encode)
  DB_PASSWORD: cGFzc3dvcmQ= # password (base64 encode)
```
2)pod.yaml
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secret-demo
spec:
  containers:
    - name: app
      image: nginx:latest
      env:
        - name: DB_USER
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: DB_USER
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: DB_PASSWORD
```
vereceyimiz paswordu ise base64 formatina ceviririk
```bash
echo -n "admin" | base64  ----> YWRtaW4=
echo -n "password" | base64  -----> cGFzc3dvcmQ=
```
ilə dəyərləri base64 formatına çevir.
# Gun-14
## 1)aws accountu uce ec2 ile bagli demek olar butun icazeleri veren policy
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:*",
        "ec2:*",
        "ec2-instance-connect:SendSSHPublicKey",
        "iam:PassRole"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams",
        "logs:GetLogEvents"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "kms:Decrypt",
        "kms:GenerateDataKey"
      ],
      "Resource": "*"
    }
  ]
}
```
# Gun-14
## instance idlerin siyahisina baxmaq
```bash
aws ec2 describe-instances --query 'Reservations[*].Instances[*].InstanceId' --output text
```
# Gun-15 
## microk8s ve kubectl aliasi
```bash
echo "alias kubectl='microk8s kubectl" >> ~/.bashrc
source ~/.bashrc
```
## ingress.yaml
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
spec:
  rules:
    - host: myapp.local
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: web-svc
                port:
                  number: 80
```
# Gun-16 
## liveness ve readiness
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-probe-demo
spec:
  containers:
    - name: nginx
      image: nginx:latest
      ports:
        - containerPort: 80
      livenessProbe:
        httpGet:
          path: /
          port: 80
        initialDelaySeconds: 5
        periodSeconds: 10
      readinessProbe:
        httpGet:
          path: /
          port: 80
        initialDelaySeconds:
        periodSeconds: 5
```
# Gun-17 
## namespace yaratmaq
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: dev-environment
```
## namespace ucun limit qoymaq
```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: dev-quota
  namespace: dev-environment
spec:
  hard:
    pods: "10"
    requests.cpu: "4"
    requests.memory: 8Gi
    limits.cpu: "8"
    limits.memory: 16Gi
```
# Gun-18 
## autoscaling -- asagidaki meselde pod 50 faizden cox cpu istifade etse pod sayi artir, cpu istifadesi azalsa yeniden pod sayi azalir
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: web-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: web-app
  minReplicas: 2
  maxReplicas: 5
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 50
```
# Gun-19
## Terraform ile aws-de ec2 yaradip ip sine baxmaq
```tf
provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0699c78c4486e5f1e"  # Regionuna uyğun AMI seç
  instance_type = "t2.micro"

  tags = {
    Name = "my-web-instance"
  }
}

output "ec2_public_ip" {
  value = aws_instance.web.public_ip
}
```

# Gun-20
## pv, pvc, ve podu pvc-e baglamaq
### pv yamli
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: learn-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/mypv"
```
### pvc yamli
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: learn-pvc-also
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```
### podun pvce-e baglanmasi
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: learn-pvc-with-pod
spec:
   containers:
     - name: nginx
       image: nginx:latest
       volumeMounts:
         - mountPath: "/usr/share/nginx/html"
           name: istediyin-adda-ola-bilen-bag
   volumes:
         - name: istediyin-adda-ola-bilen-bag
           persistentVolumeClaim:
             claimName: learn-pvc-also
```
## poda girib pathda testler aparmaq
```bash
kubectl exec -it learn-pvc-with-pod -- bash
cd /usr/share/nginx/html
echo "bu mountu yoxlamaq ucun testdir" >  test.txt
ls
cat test.txt
```
## poddan icinden cixib geri qayidib podu silek
```bash
kubectl delete pod learn-pvc-with-pod
```
## podu yeniden yaradaq
```bash
kubectl apply -f pod.yaml
```
## yeniden podun icine girib yoxlasaq orada oldugunu goreceyik
```bash
kubectl exec -it learn-pvc-with-pod -- bash
cd /usr/share/nginx/html
ls
cat test.txt
```
## 
# Gun 21
## simple github ci cd
```yaml
name: CI pipeline

on: 
 push:
   branches: [ "main" ]
   
jobs: 
 build-test:
  runs-on: ubuntu-latest

  steps:
    - name: repnu klonlayir runner masinina
      uses: actions/checkout@v4

    - name: Node.js qurasdirir runner masinina node ve npm komandalarinin istifadesi ucun
      uses: actions/setup-node@v4
      with:
         node-version: 18
         
    - name: runner masinda clida asagidaki komandani isledir package.json faylini oxuyur lazimi dependencyleri yukleyir
      run: npm install

    - name: package json faylinda test scriptlerini ise salir
      run: npm run dev
```
## pv ve storage classlarda recalim policy ve access modes
- reclaimpolicy - delete olsa pv/pvc silinse disk de avtomatik silinir nodun oz daxilindeki storage helline aiddir 
- reclaimpolicy - retaindirse pv silinse de kenarda network tipli storagede qalir
- read write once  odur ki disk nodun uzerindedirse basqa nodedaki pod bu pv-e qosual bilmez
- read write many - odur ki disk nod yox network uzerindedirse basqa nodedaki podlar da bu pvlerden istifade ede biler

# Gun 22 

## asagidaki script butun regionlarda olan ec2 lari siyahilasdirir tipini verir ve umumi sayini verir
```bash
total=0
for region in $(aws ec2 describe-regions --query "Regions[*].RegionName" --output text); do
    # Instance ID'leri al ve satır bazında say
    instance_ids=$(aws ec2 describe-instances --region $region --query "Reservations[*].Instances[*].InstanceId" --output text)
    count=$(echo "$instance_ids" | tr '\t' '\n' | grep -c .)  # boş satırları sayma
    echo "$region: $count instance"
    if [ "$count" -gt 0 ]; then
        aws ec2 describe-instances --region $region --query "Reservations[*].Instances[*].[InstanceId,InstanceType]" --output table
    fi
    total=$((total + count))
done
echo "Total EC2 instances across all regions: $total"

```
## asagidaki script awsde elastic block storageleri verir
```bash
for region in $(aws ec2 describe-regions --query "Regions[*].RegionName" --output text); do
    echo "Region: $region"
    aws ec2 describe-volumes --region $region \
        --query "Volumes[*].[VolumeId,Size,VolumeType,State,Attachments[0].InstanceId]" \
        --output table
    echo "--------------------------------------"
done
```
## awsde her tip lb-ni regiona gore verir hem classic hem de diger loadbalancerleri
```bash
for region in $(aws ec2 describe-regions --query "Regions[*].RegionName" --output text); do
    echo "Region: $region"
    
    # Classic Load Balancer (ELB v1)
    clb_count=$(aws elb describe-load-balancers --region $region --query "length(LoadBalancerDescriptions)" --output text 2>/dev/null)
    if [ "$clb_count" != "0" ] && [ "$clb_count" != "None" ]; then
        echo "Classic Load Balancers ($clb_count):"
        aws elb describe-load-balancers \
            --region $region \
            --query "LoadBalancerDescriptions[*].[LoadBalancerName,DNSName,VPCId,AvailabilityZones,Scheme]" \
            --output table
    else
        echo "No Classic Load Balancers in this region or insufficient permissions."
    fi
    
    # Application / Network / Gateway Load Balancers (ELB v2)
    alb_count=$(aws elbv2 describe-load-balancers --region $region --query "length(LoadBalancers)" --output text 2>/dev/null)
    if [ "$alb_count" != "0" ] && [ "$alb_count" != "None" ]; then
        echo "ALB/NLB/Gateway Load Balancers ($alb_count):"
        aws elbv2 describe-load-balancers \
            --region $region \
            --query "LoadBalancers[*].[LoadBalancerName,Scheme,Type,DNSName,State.Code,AvailabilityZones[*].ZoneName]" \
            --output table
    else
        echo "No ALB/NLB/Gateway Load Balancers in this region or insufficient permissions."
    fi
    
    echo "--------------------------------------"
done
```
## awsde nat gatewaylari siyahilasdirir butun regionlar ucun
```bash
for region in $(aws ec2 describe-regions --query "Regions[*].RegionName" --output text); do
    echo "Region: $region"
    aws ec2 describe-nat-gateways \
        --region $region \
        --query "NatGateways[*].[NatGatewayId,VpcId,State,SubnetId,ConnectivityType]" \
        --output table
    echo "--------------------------------------"
done

```

## asagidaki script awsde butun regionlarda rdslarin siyahisini tipini verir
```bash
regions=$(aws ec2 describe-regions --query "Regions[*].RegionName" --output text)
for region in $regions; do
    echo "Region: $region"
    for db in $(aws rds describe-db-instances --region $region --query "DBInstances[*].DBInstanceIdentifier" --output text); do
        echo "RDS Instance: $db"
        aws rds describe-db-instances \
            --region $region \
            --db-instance-identifier $db \
            --query "DBInstances[*].[DBInstanceIdentifier,DBInstanceClass,Engine,MultiAZ,AllocatedStorage,StorageType]" \
            --output table
        echo "--------------------------------------"
    done
done
```

## aws de butun regionlarda s3 bucketlerin siyahisi ve storage ucun script

```bash
for bucket in $(aws s3api list-buckets --query "Buckets[*].Name" --output text); do
    region=$(aws s3api get-bucket-location --bucket $bucket --query "LocationConstraint" --output text)
    [ "$region" == "None" ] && region="us-east-1"  # us-east-1 için özel durum
    
    echo "Bucket: $bucket (Region: $region)"
    
    if aws s3 ls s3://$bucket --region $region --recursive --summarize >/dev/null 2>&1; then
        aws s3 ls s3://$bucket --region $region --recursive --human-readable --summarize \
            | grep "Total Objects\|Total Size"
    else
        echo "Could not access bucket (check permissions or existence)"
    fi

    echo "--------------------------------------"
done

```
# Gun 23
## Kubernetes componentleri
### master node
- kube-apiserver - > kubectl emrinin getdiyi yer REST API -- tek kubectl yox butun komponenctlerin
- etcd - clusterin databsesidir, yaddasdir
- kube-controller ise kubernetesde pod sayini sabit saxlamaq ucun meselen replica 3 durse amma 1-pod dusubse qaldirir tezeden --- Qerar-vericidir
- kubec-scheduler hemin podun harada olacagini controllere deyir yeni cpu ram afinity, tain bunlari nezere alim harada qalxacagini planlayir --- node secimi 
### Worker node - pod burada isleyir 
- kubelet - api serverden melumati alir containerleri yaradir ve ya podlari
- kube-proxy servis ve networking meselelerini hell edir 

# Gun 24
## Kubernetes servisler
- podlarin ipleri sondukce deyisir ona gore servis istifade olunur
- servisler - label- selector ederek podlari tapir onlara sabit ip ve dns verir, eyni labelde olanlari loadblance edir
### cluster ip
- yalniz cluster daxilinde istifade edilir meselen front backendle danismasi ucun
### nodePort
- nodun ipsi-ni istifade ederek acir- 3000-32767 araliginda port istifade edilir
### loadbalancer
- loadbalancer - clouddan  ip alir, metallb da ise public ip almir, public ucun alb istifade etmek lazimdir
## flow beledir client servise muraciet edir servis kubeproxiye muraciet edir o da poda muraciet edir
## dns ise bele olur - servis-adi.namespace.svc.cluster.local bunu etmek ucun deployment ve servis yaradib yoxlayaq
### deployment yaml
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  labels:
    app: web
spec:
    replicas: 2
    selector:
      matchLabels:
       app: web
    template:
      metadata:
        labels:
          app: web
      spec:
        containers:
          - name: nginx
            image: nginx:latest
            ports:
              - containerPort: 80
```
### servis yaml
```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-svc
  namespace: default
spec:
 selector:
   app: web
 ports:
   - port: 80
 type: ClusterIP
```
### servisin arxasindaki podlarin iplerini ver
```bash
 kubectl get endpoint web
```
### yaranan podlardan birinin icine girib asagidaki komandani isletsek gorerik ki servis arxadaki podlar arasinda loadbalance edir
```bash
kubectl exec -it web-app-6c79984869-5dwt7 -- curl http://web-svc.default.svc.cluster.local
```
## aws de loadbalancer ve metallb istifade etmek
### metal lb ucun asagida ip araligi veririk sonra servis yaml apply edirik
```bash
 microk8s enable metallb 172.31.15.240-172.41.15.250
```
 ```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-lb
spec:
  type: LoadBalancer
  selector:
    app: web
  ports:
    - port: 80
      targetPort: 80
```
## aws loadbalanceri istifade etmek ucun metallb ni silmek lazimdir
- aws loadbalancer da hem private hem de public ip vere bilir, bunun ucun awsde subnet route table ve internet gateway duzgun qurasdirilmali ve attach edilmelidir

# Gun 25
## Subnetting
### ipv4 unvanlari 4 ededden ibaretdir, x.y.z.d bu ededler oktet adlanir 8 bit olur  meselen 10.0.0.0 heresi 8 reqemli sekilde tesvir edile biliner
### yəni 10.0.0.0 her biri decimal reqeblerdir onlari binarie cevirende 8 eded 0 ve 1 le ifade olunur
### meselen 10 reqeminin binariye cevrilmei:
bitler bele gedir |128|64|32|16|8|4|2|1|
sira ile gedirik 10 ucun -- 10 bele verile biler 1 dene 2 birdene 2 
         |128|64|32|16|8|4|2|1|
1 bele olur 0  0  0  0 0 0 0 1
2 bele olur 0  0  0  0 0 0 1 0
3 bele olur 0  0  0  0 0 0 1 1
4 bele olur 0  0  0  0 0 1 0 0
.
.
.
10 bele olur 0  0  0  0 1 0 1 0
0 lar ise hamisi 0 olur 

0  0  0  0 1 0 1 0. 00000000 . 00000000 . 00000000  -----> 32 bit olur umumi 
cidr /16 dirsa ilk 16 sebekedir 32 den 16 cixiriq qalani hostdur 
/16 ucun host sayi bele olur 2*(32-16)= 65336 ip verile biliner

           |128|64|32|16|8|4|2|1|
16 bele olur 11111111.11111111.00000000.0000000
10.0.0.0/16 ---> o demekdir ki 10.0 sabit qalani deyise biler 10.0.255.255 ola biler
/16 cidrini 16 dan boyuk istenilen subnete bolmek olar amma 15 ve kiciye olmaz /24 olar meselen

/24 ucun 2^(24-16) = 256 256 network sayi var demekdir
/24 o demekdir ki ilk 24 sebeke ucun son 8 bit ise host ucun
host sayi 2^8= 256 ip var host ucun
yeni /16 da 16 bit evvel host ucun idi indi ise /24 olduguna gore 8 biti qaldi hosta 8 biti subnete verildi
/24 olandan sonra subnetler 
10.0.0.0 /24
10.0.1.0 /24
10.0.2.0 /24
10.0.255.0 /24
yeni /24 cid ucun 256 sebekei yaranir 





## VPS - aws hesabinda izolyasya olunmiv virtual sebekeidr onun icinde subnetler routetableler internet gatewaylar nat gatewayler security grouplar Nacl lar var
### VPS yaradilmasi
#### default 172.31.0.0/16 olur, ozumuz ize /16 (65536 ip)  ve /28 ( 16ip) araliginda vermeliyik
#### 3 kategoriyada
-  10.0.0.0/16 boyuk vpc
-  172.16.0.0/12 orta vpc
-  192.168.0.0/16 kicik vpc 
#### vpc- in terraform ile yaradilmasi ve silinmesi 
```tf
provider "aws" {
  region = "eu-central-1"
}

resource "aws_vpc" "my_portfolio" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "my-portfolio-vpc"
  }
}
```
```bash
terraform init
#terraform init main.tf - daki providerleri yeni tercumecileri yukleyir aws kimi - aws api ile danismasi ucun lazimdir, state fayli hazirlayir
terraform plan
terraform apply
```
# Gun 26
## VPC ler region uzre verilir her region ucun bir default vpc, 
## Subnet ise her vpc ucun 3 eded ferqli zonalarda veriir high aviilability ucun
- eu-central-1a
- eu-central-1b
- eu-central-1c
