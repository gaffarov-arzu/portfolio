1)minio qurmaq 
docker run -d --name minio \
  -p 9000:9000 \
  -p 9001:9001 \
  -e MINIO_ROOT_USER=admin \
  -e MINIO_ROOT_PASSWORD=supersecretpassword \
  -v /home/ubuntu/minio-data:/data \
  minio/minio server /data --console-address ":9001"

2)mc qurmaq
wget https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x mc
sudo mv mc /usr/local/bin/
3)mc alias set myminio http://127.0.0.1:9000 admin supersecretpassword --api S3v4
4)bucket yaratmaq
mc alias set myminio http://127.0.0.1:9000 admin supersecretpassword --api S3v4
5)bucketleri list elemek
mc ls myminio
6) policy yaratmaq
nano dev-policy.json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource": [
        "arn:aws:s3:::dev-bucket/*"
      ]
    }
  ]
}
7)policy yaratmaq
mc admin policy create myminio dev-policy dev-policy.json
8)user yaratmaq
mc admin user add myminio dev-user secretpassword
9)policyni usere ttach elemek



