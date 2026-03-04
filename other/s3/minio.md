# MinIO qurmaq:
```bash
docker run -d --name minio -p 9000:9000 -p 9001:9001 -e MINIO_ROOT_USER=admin -e MINIO_ROOT_PASSWORD=supersecretpassword -v /home/ubuntu/minio-data:/data minio/minio server /data --console-address ":9001"
```

# mc qurmaq:
```bash
wget https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x mc
sudo mv mc /usr/local/bin/
```

# mc alias set etmək:
```bash
mc alias set myminio http://127.0.0.1:9000 admin supersecretpassword --api S3v4
```

# Bucket yaratmaq:
```bash 
mc mb myminio/dev-bucket
```

# Bucketləri list etmək:
```bash 
mc ls myminio
```

# Policy yaratmaq (dev-policy.json):
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject","s3:PutObject","s3:DeleteObject"],
      "Resource": ["arn:aws:s3:::dev-bucket/*"]
    }
  ]
}

```
# Policy MinIO’ya əlavə etmək:
```bash 
mc admin policy create myminio dev-policy dev-policy.json
```

# User yaratmaq:
```bash 
 mc admin user add myminio dev-user dev-password123

```
# Policy’yi user-ə attach etmək:
```bash 
mc admin policy attach myminio dev-policy --user dev-user
```
