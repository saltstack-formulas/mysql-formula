# This create a passwordless access for root
mysql_root_my_cnf:
  file.managed:
    - name: /root/.my.cnf
    - source: salt://mysql/files/root-my.cnf
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - create: True
