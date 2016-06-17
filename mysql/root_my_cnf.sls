#
# This create a passwordless access for root
# See: https://github.com/saltstack-formulas/mysql-formula/issues/120 for discussion about security
#
#
# Usage: salt-call mysql.root_my_cnf

mysql_root_my_cnf:
  file.managed:
    - name: /root/.my.cnf
    - source: salt://mysql/files/root-my.cnf
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - create: True

# This use above config file to store mysql's root password for salt
mysql_minion_root_my_cnf:
  file.managed:
    - name: /etc/salt/minion.d/55-mysql-cnf.conf
    # use quote for the content
    - contents:
      - "mysql.default_file: '/root/.my.cnf'"
    - user: root
    - group: root
    - mode: 600
    - create: True
    - require:
      - file: mysql_root_my_cnf
