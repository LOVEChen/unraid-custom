#!/bin/bash

mkdir -p /boot/unraid-custom/packages
cd /boot/unraid-custom/packages

# deps.
[ ! -f "curl-7.20.1-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/n/curl-7.20.1-i486-1.txz
[ ! -f "git-1.7.1-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/d/git-1.7.1-i486-1.txz
[ ! -f "python-2.6.4-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/d/python-2.6.4-i486-1.txz
[ ! -f "python-cheetah-2.4.2.1-i486-1alien.tgz" ] && wget http://connie.slackware.com/~alien/slackbuilds/python-cheetah/pkg/13.0/python-cheetah-2.4.2.1-i486-1alien.tgz
[ ! -f "sqlite-3.6.23.1-i486-1.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/ap/sqlite-3.6.23.1-i486-1.txz

[ ! -x "/usr/bin/curl" ] && installpkg curl-7.20.1-i486-1.txz
[ ! -x "/usr/bin/git" ] && installpkg git-1.7.1-i486-1.txz
[ ! -x "/usr/bin/python" ] && installpkg python-2.6.4-i486-1.txz
[ ! -d "/usr/lib/python2.6/site-packages/Cheetah" ] && installpkg python-cheetah-2.4.2.1-i486-1alien.tgz
[ ! -x "/usr/bin/sqlite3" ] && installpkg sqlite-3.6.23.1-i486-1.txz

# source.
if [ ! -d "/boot/unraid-custom/Sick-Beard" ]; then
    git clone https://github.com/midgetspy/Sick-Beard.git /boot/unraid-custom/Sick-Beard
fi

# config.
cd /boot/unraid-custom/Sick-Beard
[ ! -f "sickbeard.ini" ] && cp /boot/unraid-custom/etc/sickbeard.ini sickbeard.ini

# run.
if [ test -a $(ps auxwww|grep SickBeard.py|grep -v grep|wc -l) -lt 1 ]; then
	LOG_DIR=$(awk -F ' = ' '$1 == "log_dir" {print $2}' sickbeard.ini)
	mkdir -p "$LOG_DIR"
	chown -R nobody:users "$LOG_DIR"
	usermod -s /bin/bash nobody > /dev/null 2>&1
	su nobody -c "python SickBeard.py --daemon > /dev/null 2>&1"
else
	echo Sick Beard is already running.
fi
