# 1. system:masters (Super-Admin) qrupuna aid sertifikat yaradıldı
openssl genrsa -out /tmp/admin.key 2048
openssl req -new -key /tmp/admin.key -out /tmp/admin.csr -subj "/CN=kubernetes-admin/O=system:masters"
openssl x509 -req -in /tmp/admin.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out /tmp/admin.crt -days 365

# 2. Yeni sertifikat admin.conf faylına daxil edildi
kubectl config set-credentials kubernetes-admin --client-certificate=/tmp/admin.crt --client-key=/tmp/admin.key --embed-certs=true --kubeconfig=/etc/kubernetes/admin.conf

# 3. Konfiqurasiya istifadəçinin profili kimi tətbiq edildi
cp /etc/kubernetes/admin.conf ~/.kube/config

# 4. Yoxlanış və təmizlik
kubectl get pods -A
rm -f /tmp/admin.key /tmp/admin.csr /tmp/admin.crt
