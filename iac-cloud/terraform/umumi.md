# terraform ile bucket yaratmaq
## .tf fayli yaradiriq
```bash
vim main.tf
```
```tf
provider "aws" {
  region = "us-east-1"
}
resource "aws_s3_bucket" "example" {
  bucket = "benim-ilk-bucket-12345"
  acl    = "private"
}
```
## initialize edirik
```bash
terraform init
```
## asagidaki komanda ile ne deyiseceyine baxiriq
```bash
terraform plan
```
## asagidaki komanda ile apply edilir o gosterilen deyisilecek seyler
```bash 
terraform apply
```
