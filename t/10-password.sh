#!lib/test-in-container-systemd.sh mariadb

set -ex

# hack the pillar
mkdir -p /srv/pillar
echo "
mysql:
  server:
    mysqld:
      max_allowed_packet: 1111040
  database:
    - testdb
  user:
    myuser1:
      password: 'mypass123'
      host: localhost
      databases:
        - database: testdb
          grants: ['all']
" > /srv/pillar/testdata.sls

echo '
{{ saltenv }}:
  "*":
    - testdata
' >> /srv/pillar/top.sls


salt-call --local pillar.get mysql:user:myuser1:password
salt-call --local pillar.item mysql:user:myuser1:password | grep mypass123

pass=$(echo $(salt-call --local pillar.get mysql:user:myuser1:password) | tail -n 1 | grep -Eo '[^ ]+$')
test "$pass" == mypass123

salt-call --local state.apply 'mysql'
salt-call --local state.apply 'mysql.remove_test_database'

set -a
shopt -s expand_aliases
alias sql="mariadb -h 127.0.0.1 -umyuser1 -p$pass -e"
(

sql 'select user(), current_user(), version()'

packet="$(sql 'show variables like "max_allowed_packet"' -Nb)"
test 1111040 == ${packet//[!0-9]/}

echo test access denied to mysql database
rc=0
sql 'select user, host from mysql.user' || rc=$?
test "$rc" -gt 0

echo test wrong password is denied
rc=0
sql 'select user(), current_user(), version()' -p"wrongpassword" || rc=$?
test "$rc" -gt 0
)

service mariadb status || service mysql status

echo success
