# microk8s qurasdirilmasi
```bash
snap install microk8s --classic
sudo usermod -a -G microk8s $USER
sudo chown -f -R $USER ~/.kube
newgrp microk8s 
microk8s status --wait-ready
echo "alias kubectl='microk8s kubectl'" >> ~/.bashrc
```

# mirok8sde hostpath yaratmaq bu o demekdir ki pv avtomatik yaratsin el ile yaratmada
```bash
microk8s enable hostpath-storage
```
# microk8sde ingress enable etmek
```bash
microk8s enable ingress
```
