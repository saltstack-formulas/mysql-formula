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

{% if salt['pillar.get'](['mysql', 'schema', database, 'load']|join(':'), False) %}
{{ state_id }}_schema:
  file.managed:
    - name: /etc/mysql/{{ database }}.schema
    - source: {{ salt['pillar.get'](['mysql', 'schema', database, 'source']|join(':')) }}
    - user: {{ salt['pillar.get']('mysql:server:user', 'mysql') }}

{{ state_id }}_load:
  cmd.wait:
    - name: mysql -u root -p{{ mysql_root_pass }} {{ database }} < /etc/mysql/{{ database }}.schema
    - watch:
      - file: {{ state_id }}_schema
      - mysql_database: {{ state_id }}
{% endif %}

{% do db_states.append(state_id) %}
{% endfor %}
