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
