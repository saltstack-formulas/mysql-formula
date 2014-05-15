{% from "mysql/map.jinja" import mysql with context %}

include:
  - mysql.python

{% for database in salt['pillar.get']('mysql:database', []) %}
{{ database }}:
  mysql_database.present:
    - host: localhost
    - connection_user: root
    - connection_pass: '{{ salt['pillar.get']('mysql:server:root_password', 'somepass') }}'
    - connection_charset: utf8
{% endfor %}


