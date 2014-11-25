{% set mysql_root_pass = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}

include:
  - mysql.python

mysql remove test database:
  mysql_database.absent:
    - name: test
    - host: localhost
    - connection_user: root
    {% if mysql_root_pass %}
    - connection_pass: '{{ mysql_root_pass }}'
    {% endif %}
    - connection_charset: utf8
