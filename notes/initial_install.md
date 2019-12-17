# Notes from initial install

On the Linux worker, PLPduck, I disabled the Jenkins service:

```
sudo update-rc.d jenkins disable
```

On the server, I installed the buildbot service:

```
cp /home/bb/repos/psychopy-bb/config/buildbot /etc/init.d/
chkconfig --add buildbot
chmod u+x /etc/init.d/buildbot 
service buildbot start
```
