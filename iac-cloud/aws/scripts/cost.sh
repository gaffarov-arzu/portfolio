#!/bin/bash

# AWS CLI local credentials kullanacak
export AWS_PROFILE=default

# Tarih aralığı (son 30 gün)
START_DATE=$(date -d "-30 days" +%Y-%m-%d)
END_DATE=$(date +%Y-%m-%d)

echo "AWS Maliyet Sorgulama"
echo "1) Son 1 ayın toplam maliyeti"
echo "2) Tüm bölgelerin maliyeti"
echo "3) Belirli bir bölgenin maliyeti"
echo "4) Belirli bir servisin maliyeti"
echo "5) Tüm servislerin maliyeti"

read -p "Bir seçenek girin (1-5): " choice

case $choice in
  1)
    echo ""
    echo "===== Son 1 Ayın Toplam Maliyeti ====="
    aws ce get-cost-and-usage \
      --time-period Start=$START_DATE,End=$END_DATE \
      --granularity MONTHLY \
      --metrics "BlendedCost" \
      --output table
    ;;

  2)
    echo ""
    echo "===== Tüm Bölgelerin Maliyeti ====="
    regions=($(aws ec2 describe-regions --query 'Regions[*].RegionName' --output text))
    for region in "${regions[@]}"; do
      cost=$(aws ce get-cost-and-usage \
        --time-period Start=$START_DATE,End=$END_DATE \
        --granularity MONTHLY \
        --metrics "BlendedCost" \
        --filter "{\"Dimensions\":{\"Key\":\"REGION\",\"Values\":[\"$region\"]}}" \
        --output text | grep BlendedCost | awk '{print $2, $3}')
      echo "Region: $region, Cost: $cost"
    done
    ;;

  3)
    read -p "Bölge ismini girin (örnek: us-east-1): " REGION
    echo ""
    echo "===== $REGION Bölgesinin Maliyeti ====="
    aws ce get-cost-and-usage \
      --time-period Start=$START_DATE,End=$END_DATE \
      --granularity MONTHLY \
      --metrics "BlendedCost" \
      --filter "{\"Dimensions\":{\"Key\":\"REGION\",\"Values\":[\"$REGION\"]}}" \
      --output table
    ;;

  4)
    read -p "Servis ismini girin (örnek: AmazonEC2, AmazonS3): " SERVICE
    echo ""
    echo "===== $SERVICE Servisinin Maliyeti ====="
    aws ce get-cost-and-usage \
      --time-period Start=$START_DATE,End=$END_DATE \
      --granularity MONTHLY \
      --metrics "BlendedCost" \
      --filter "{\"Dimensions\":{\"Key\":\"SERVICE\",\"Values\":[\"$SERVICE\"]}}" \
      --output table
    ;;

  5)
    echo ""
    echo "===== Tüm Servislerin Maliyeti ====="
    services=("AmazonEC2" "AmazonS3" "AmazonRDS" "AWSLambda" "AmazonEFS" "AmazonVPC")
    for svc in "${services[@]}"; do
      cost=$(aws ce get-cost-and-usage \
        --time-period Start=$START_DATE,End=$END_DATE \
        --granularity MONTHLY \
        --metrics "BlendedCost" \
        --filter "{\"Dimensions\":{\"Key\":\"SERVICE\",\"Values\":[\"$svc\"]}}" \
        --output text | grep BlendedCost | awk '{print $2, $3}')
      echo "Service: $svc, Cost: $cost"
    done
    ;;

  *)
    echo "Geçersiz seçenek."
    ;;
esac

echo ""
echo "========== Maliyet Sorgulama Tamamlandı =========="
