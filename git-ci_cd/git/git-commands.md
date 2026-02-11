# Git commands
## Gitde hemiselik logini save etmek
```bash
git config --global credential.helper store
```

## Remotedaki reponu getirib amma apply etmemek ucun
git fetch origin - 
git reset --hard origin/main local reponu - remote reponun eynisi halina getirir
git clean -fd izlenmeyen ve commit edilmemiseleri silir
git pull origin main ( hem git fetch edir hem de git merge edir)

  git branch -a (hem localda hem de remoteda olan branchlar)
git branch -r (remotedaki branchlar)
git push origin --delete a.qafarov-main-patch-91526 (branch silmek)


git proyektini remote push etmek
1)git init
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
