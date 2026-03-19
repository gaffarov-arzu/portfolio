
# terraform qurasdirilmasi
## evvelce yoxlayaq
```bash
terraform --version
```
## sonra install edek
```bash
snap install terraform --classic
```
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
### terraform init ne edir
- providerlerle danismaq ucun aws azure, google cloud la danismaq ucun lazimi seyleri endirir
- backendin haradan oxuyacagini mueyyenlesdirir localdan yoxsa remotedan kodda ise remoteda olan s3 bucket gosterilir
- module endirir main.tf icinde olur hazir modullar olur
- terraform.locl.hcl a baxim sabit versiya yukleyir meselen aws provider guncellense yenilemir o fayla baxir
- .terraform directorisini yaradir - icinde cloud providerlerle danismaq ucun binariler var, hazir yuklenen modullar var

### terraformda backend asagidaki kimi verilir
```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "prod/terraform.tfstate"
    region = "us-east-1"
  }
}
```
## asagidaki komanda ile ne deyiseceyine baxiriq
```bash
terraform plan
```
## asagidaki komanda ile apply edilir o gosterilen deyisilecek seyler
```bash 
terraform apply
```
