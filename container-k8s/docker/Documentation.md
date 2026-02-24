# General
## githubda runner hansi userle start olursa o user de gedib dockeri isledir serverde
# neticede docker engine ucun icazesi olmaya biler ona gore de asagidaki komandani isledirik sonra runner servisini restart edirik
```bash
sudo usermod -aG docker devops
sudo systemctl restart actions.runner.ieltsfly-ieltsfly-landing.ielts-front.service
```
## dockerhubda image nin olub olmadigini yoxlamaq ucun
```bash
docker search privacyidea
```
# containerde deyisiklik edib image halina getirib sonra yene run ede bilerik yeni davamli qalsin deye
```bash
docker commit container-id yeni-image:modified
```
