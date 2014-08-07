{% from "mysql/map.jinja" import mysql with context %}

{% set user_states = [] %}

include:
  - mysql.python

{% for user in salt['pillar.get']('mysql:user', []) %}
{% set state_id = 'mysql_user_' ~ loop.index0 %}
{{ state_id }}:
  mysql_user.present:
    - name: {{ user['name'] }}
    - host: '{{ user['host'] }}'
  {%- if user['password_hash'] is defined %}
    - password_hash: '{{ user['password_hash'] }}'
  {%- elif user['password'] is defined and user['password'] != None %}
    - password: '{{ user['password'] }}'
  {%- else %}
    - allow_passwordless: True
  {%- endif %}
    - connection_host: localhost
    - connection_user: root
    - connection_pass: '{{ salt['pillar.get']('mysql:server:root_password', 'somepass') }}'
    - connection_charset: utf8

{% for db in user['databases'] %}
{{ state_id ~ '_' ~ loop.index0 }}:
  mysql_grants.present:
    - name: {{ user['name'] ~ '_' ~ db['database'] }}
    - grant: {{db['grants']|join(",")}}
    - database: '{{ db['database'] }}.*'
    - user: {{ user['name'] }}
    - host: '{{ user['host'] }}'
    - connection_host: localhost
    - connection_user: root
    - connection_pass: '{{ salt['pillar.get']('mysql:server:root_password', 'somepass') }}'
    - connection_charset: utf8
    - require:
      - mysql_user: {{ user['name'] }}
{% endfor %}

{% do user_states.append(state_id) %}
{% endfor %}


