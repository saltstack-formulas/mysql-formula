{% from "mysql/map.jinja" import mysql with context %}

include:
  - mysql.python

{% for user in salt['pillar.get']('mysql:user', []) %}
mysql_user_{{ user['name'] }}:
  mysql_user.present:
    - name: {{ user['name'] }}
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
{% set name = user['name'] ~ '_' ~ db['database'] %}
mysql_user_{{ name }}:
  mysql_grants.present:
    - name: {{ name }}
    - grant: {{db['grants']|join(",")}}
    - database: '{{ db['database'] }}.{{ db['table'] | default('*') }}'
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


