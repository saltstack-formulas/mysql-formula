{% from "mysql/map.jinja" import mysql with context %}

include:
  - mysql.python

{% for user in salt['pillar.get']('mysql:user', []) %}
{{ user['name'] }}:
  mysql_user.present:
    - host: {{ user['host'] }}
  {%- if user['password_hash'] is defined %}
    - password_hash: '{{ user['password_hash'] }}'
  {% else %}
    - password: '{{ user['password'] }}'
  {% endif %}
    - connection_host: localhost
    - connection_user: root
    - connection_pass: '{{ salt['pillar.get']('mysql:server:root_password', 'somepass') }}'
    - connection_charset: utf8

{% for db in user['databases'] %}
{{ user['name'] }}_{{ db['database'] }}:
  mysql_grants.present:
    - grant: {{db['grants']|join(",")}}
    - database: {{ db['database'] }}.*
    - user: {{ user['name'] }}
    - host: {{ user['host'] }}
    - connection_host: localhost
    - connection_user: root
    - connection_pass: '{{ salt['pillar.get']('mysql:server:root_password', 'somepass') }}'
    - connection_charset: utf8
    - require:
      - mysql_user: {{ user['name'] }}
{% endfor %}

{% endfor %}


