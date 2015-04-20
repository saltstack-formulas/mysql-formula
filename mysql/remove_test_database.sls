{% set mysql_root_pass = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}
{% set mysql_host = salt['pillar.get']('mysql:server:host', 'localhost') %}

include:
  - mysql.python

mysql remove test database:
  mysql_database.absent:
    - name: test
    - host: '{{ mysql_host }}'
    - connection_user: root
    {% if mysql_root_pass %}
    - connection_pass: '{{ mysql_root_pass }}'
    {% endif %}
    - connection_charset: utf8
