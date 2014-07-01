{% from "mysql/map.jinja" import mysql with context %}

{% set mysql_root_pass = salt['pillar.get']('mysql:server:root_password', salt['test.rand_str'](64)) %}
{% set db_states = [] %}

include:
  - mysql.python

{% for database in salt['pillar.get']('mysql:database', []) %}
{% set state_id = 'mysql_db_' ~ loop.index0 %}
{{ state_id }}:
  mysql_database.present:
    - name: {{ database }}
    - host: localhost
    - connection_user: root
    - connection_pass: '{{ mysql_root_pass }}'
    - connection_charset: utf8

{% do db_states.append(state_id) %}
{% endfor %}
