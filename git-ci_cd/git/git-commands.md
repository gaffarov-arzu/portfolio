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
## asagidaki komanda pull edib amma konflikt yoxdursa eger ise yarayir, fetchden ferqi locala deyisiklik edir
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

## git proyektini remote push etmek
```bash
git init
```

2)remotedaki adla elave edirik
  git remote add origin https://github.com/gaffarov-arzu/life-all-asspects.git
amma evvelce eger baska origin varsa bize lazim olmayan silirik git remote remove origin
amma biz origini saxlayib basqa adla da yaza bilerik origin connection demekdir
git remote add backup https://github.com/gaffarov-arzu/life-all-asspects.git
daha sonra ise 
  git add .
git commit -m "Initial commit"
git branch -M main       # GitHub default branch main ise
git push -u origin main

## gitde git add * shellde gorunenleri edir git add . herseyi gizli olanlari da edir
 ## git reponun icinde basqa gir repo qoymaq ve githubda webde baxmaq
 git rm --cached -r immigrate-bucket
 git commit -m 'a'
 git submodule add https://github.com/gaffarov-arzu/immigrate-bucket.git
local ve remote arasindaki ferqleri gormek ucun
 git log --oneline --graph --decorate --all

 
