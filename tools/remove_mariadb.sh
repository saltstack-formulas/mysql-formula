#!/bin/bash
#
# remove mariaDB from debian jessie, so you can redo the formula
# Note: very destroying script.
# Usage: 
#   scp remove_mariadb.sh minion:
#   ssh minion
#   chmod a+x ./remove_mariadb.sh
#   ./remove_mariadb.sh
# with salt:
#   salt-cp 'minion' ./remove_mariadb.sh /root
#   salt 'minion' cmd.run "chmod a+x remove_mariadb.sh && ./remove_mariadb.sh"
service mysql stop
apt-get remove -y --purge $(dpkg -l | awk '/mysql|maria/ { print $2 } ')
rm -rf /etc/mysql/
rm -rf /var/lib/mysql/
echo PURGE | debconf-communicate mysql-server
echo PURGE | debconf-communicate mariadb-server-10.0
echo PURGE | debconf-communicate mariadb-server
debconf-get-selections | egrep 'maria|mysql'
