#!lib/test-in-container-systemd.sh mariadb

set -ex

salt-call --local state.apply 'mysql'
salt-call --local state.apply 'mysql.remove_test_database'

mysql -e 'select user(), current_user(), version()'

service mysql status

echo success
