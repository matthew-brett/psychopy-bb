# Install buildbot master and workers

## Master

### Create Buildbot master account

See : <http://buildbot.net/#/basics>

A *worker* is a machine that runs builds and reports back with results.

A *master* is a process that controls the workers. It polls for changes
that should trigger a build, and then sends these changes to the
build workers to run the build.

Please see the [main buildbot documentation](http://docs.buildbot.net/current)
for more detail.

### Create buildbot user account

Password is disabled by default in Fedora/Red Hat/CentOS:

```
useradd buildbot
```

Put in public ssh key for own account and host buildbot account.

Note that CentOS5 seems to require .ssh/authorized\_keys chmod go-rwx.

```
su - buildbot
mkdir .ssh
chmod go-rwx .ssh
```

scp your key to `.ssh/authorized_keys`

```
chmod go-rwx .ssh/authorized_keys
```

### Install buildbot locally

```
pip install --user -U buildbot
```

Add path in `.bashrc`:

```
# User specific aliases and functions

pathmunge () {
    case ":${PATH}:" in
        *:"$1":*)
            ;;
        *)
            if [ "$2" = "after" ] ; then
                PATH=$PATH:$1
            else
                PATH=$1:$PATH
            fi
    esac
}

pathmunge ~/.local/bin

export PATH
unset pathmunge
```

### Install buildmaster

```
pip install --user -r requirements.txt
```

### Maybe make directories for try scheduler

See : <http://docs.buildbot.net/latest/full.html#sched-Try_Jobdir>

```
mkdir -p jodbdir jobdir/new jobdir/cur jobdir/tmp
```

This enables the `jobdir` scheduler for anyone who can ssh into the
master account machine.

### Create buildbot service

Create `/etc/init.d/buildbot` with the following content in `config/buildbot`.

Enable it:

```
chkconfig --add buildbot
```

### Enable public website

Install `mod_proxy`:

```
yum install mod_proxy_html
```

Add buildbot proxy conf in `/etc/httpd/conf.d/buildbot.conf`:

```
ProxyPass / http://localhost:8010/
ProxyPassReverse / http://localhost:8010/
```

Enable Apache:

```
chkconfig httpd on
service httpd start
```

Open port 80 by adding the following to `/etc/sysconfig/iptables`:

```
-A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
```

## Setting up a build worker

On master:

Add build worker name and password (below) to `psychopy_private.toml` and:

```
buildbot reconfig master
```

In this case on Debian / Ubuntu:

```
WORKER_USER=buildworker
WORKER_NAME=my_worker
WORKER_PASSWORD=some-password-not-this-one

sudo useradd -m $WORKER_USER
sudo passwd $WORKER_USER
# You'll need python and git and nosetests on the path
sudo apt-get install git python-dev python-numpy python-nose python-setuptools
# Tests need virtualenv, it's easiest to install this system-wide
pip install virtualenv
su - $WORKER_USER
pip install --user buildbot-worker
# Create build worker
$HOME/.local/bin/buildbot-worker create-worker $HOME/$WORKER_NAME buildbot.psychopy.org $WORKER_NAME $WORKER_PASSWORD
# At this point you may want to edit the `admin` and `host` files in $HOME/$WORKER_NAME/info
# Start up build worker
$HOME/.local/bin/buildbot-worker start $HOME/$WORKER_NAME
# Make sure worker starts on reboot
cat > crontab.txt << EOF
PATH=$HOME/.local/bin:/usr/local/bin:/bin
@reboot $HOME/.local/bin/buildbot-worker start $HOME/$WORKER_NAME
EOF
crontab crontab.txt
```

For macOS - instructions are similar. You will need to run the build worker
via launchd - see <http://trac.buildbot.net/wiki/UsingLaunchd>. This
involves making a `.plist` file, putting it into
`/Library/LaunchDaemons`, setting user and group to be `root:wheel`, and
either rebooting, or running `launchctl load the-plist-file.plist` to start the
daemon. See the example `.plist` files in this directory. If you don't do this,
and just run `buildbot-worker`, then the builds will tend to die with DNS
errors.

## Local testing

For those times you want to test on your laptop, etc:

```
git clone https://github.com/matthew-brett/psychopy-bb
cd psychopy-bb
make clean-master
make master
make local
```

You might also want to set up a local worker with `scripts/make_local_worker.sh`.
