## crontabi simulasya ucun
```bash
sudo -u root -H env -i bash -c '/usr/local/bin/git_auto_push.sh'
```
## crontabda automatic githuba push scripti islemese directoryye asagidaki settingleri veririrk
```bash
sudo git config --global --add safe.directory /home/ubuntu/musluck.com-vibecoded
```
## crontabda gunde bir defe saat ikide 
```bash
0 2 * * *
``` 
## crontabda 12 saatdan bir
```bash
0 */12 * * *
```
