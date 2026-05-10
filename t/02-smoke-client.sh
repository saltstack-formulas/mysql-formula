#!lib/test-in-container-systemd.sh mariadb-client

set -ex

#########################
# workaround for https://github.com/saltstack-formulas/mysql-formula/issues/267
( grep -qi debian /etc/*release && mkdir -p /etc/mysql ) || \
    ( grep -qi suse /etc/*release && mkdir -p /etc/my.cnf.d ) || \
    :
#########################

salt-call --local state.apply 'mysql.client'

mariadb -V || mysql -V

# check mysqld service is not installed
rc=0
service mysql status || rc=$?
test $rc -gt 0

rc=0
service mysql status || rc=$?
test $rc -gt 0

rc=0
service mariadb status || rc=$?
test $rc -gt 0

echo success
