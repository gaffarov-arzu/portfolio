# Git commands
## Gitde hemiselik logini save etmek
```bash
git config --global credential.helper store
```

## Asagidaki komanda reponu getirir amma apply etmir
```bash 
git fetch origin
```
## asagidaki komanda remote reponu getirir localin userine yazir 
```bash
git reset --hard origin/main
```
## asagidaki komanda izlenmeyen ve commit edilmemeisleri silir
```bash
git clean -fd izlenmeyen ve commit edilmemiseleri silir
```
## asagidaki komanda pull edib amma konflikt yoxdursa eger ise yarayir, fetchden ferqi locala deyisiklik edir yeni asagidaki commit hem fetch edir hem merge edir
```bash
git pull origin main
```

## hem localda hem de remoteda olan branchlar
```bash
git branch -a 
```
## remotedaki branchlar
```bash
git branch -r (remotedaki branchlar)
```

## remote branch silmek 
```bash
git push origin --delete a.qafarov-main-patch-91526 
```
## localda branchi silmek ucun merge edilibse -d yeni normal silme edilmeyibse -D yeni force, merge edilmemeyi deyisikliyin yadda saxlanmayib demekdir ona gore -d islemir
```bash
git branch -d
git branch -D
```bash
## branch deyismek
```bash
git branch feature-1
```
## yeni branch yaratmaq
```bash
git checkout -b feature-1
```
## gitde branch deyismek
```bash
git checkout dev
```
## asagidaki kommanda ise elece branch yaradir checkout kimi hansisa branchdan yaratmir
```bash
git branch yeni-branch
```
## git proyektini remote push etmek
### evvelce asagidaki kommandani yaziriq tarixce kimi birseydir
```bash
git init
```
### daha sonra remotedaki adla elave edirik
```bash
git remote add origin https://github.com/gaffarov-arzu/life-all-asspects.git
```
### amma evvelce eger basqa origin varsa bize lazim olmayan silirik
```bash
git remote remove origin
```
### amma biz origini saxlayib basqa adla da yaza bilerik origin connection demekdir
```bash git remote add backup https://github.com/gaffarov-arzu/life-all-asspects.git
```
### sonra ise 
```bash
git add .
git commit -m "Initial commit"
git branch -M main       # GitHub default branch main ise
git push -u origin main
```
## gitde add * shellde gorunenleri edir git add . herseyi gizli olanlari da edir
## git reponun icinde basqa git repo qoymaq ve githubda webde baxmaq
```bash
 git rm --cached -r immigrate-bucket
 git commit -m 'a'
 git submodule add https://github.com/gaffarov-arzu/immigrate-bucket.git
```
## local ve remote arasindaki ferqleri gormek ucun
 ```bash
 git log --oneline --graph --decorate --all
```
## localda olan remoteda olmayan commitleri gormek
```bash
git log origin/main..main --oneline
```
## remoteda olan localda olmayanlari gormek
```bash
git log main..origin/main --oneline
```
## remote ve local arasinda ferqleri vizual gosterir
```bash
git log --oneline --graph --decorate --all
```
## gite automatic push etmek ucun evvelse ssh-public keyi githuba elave etmek lazimdir daha sonra https yox asagidaki kimi ssh ile set etmek lazimdir
```bash
git remote set-url origin git@github.com:gaffarov-arzu/life-pro.git
```
## linuxda crontab ile reponun automatic git remote push edilmesi scripti
```bash
#!/bin/bash
cd /home/ubuntu/life-pro || exit
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
/usr/bin/git add .
/usr/bin/git commit -m "Auto commit: $(date '+%Y-%m-%d %H:%M:%S')" || exit
/usr/bin/git push origin main
```
## crontabda yes sorusa bilmir amma ssh la qosulanda ilk defe dogrulama sorusur onun ucun userin known host faylina elave edirik bu githubun oz public keyidir
```bash
ssh-keyscan github.com >> /root/.ssh/known_hosts
```
## crontaba yazilmasi
```bash
0 2 * * * /usr/local/bin/git_auto_push.sh
```
## script islemesinde problem ola biler folder permissionuna gore ona gore o folderi safe edirik asagidaki command ilep
```bash
git config --global --add safe.directory /home/ubuntu/life-pro
```
## gitde local ve remote branchlari bir birinden ferqli deyisikliklere sahibdirse 
```bash
git pull --no-rebase origin main
```
## gitde istenilen commite donmek
```bash
 git reset --hard a31c9241c1ae18d624c020211dddac0656c0463a
```
