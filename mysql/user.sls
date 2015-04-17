{% from "mysql/defaults.yaml" import rawmap with context %}
{%- set mysql = salt['grains.filter_by'](rawmap, grain='os', merge=salt['pillar.get']('mysql:server:lookup')) %}
{%- set mysql_root_pass = salt['pillar.get']('mysql:server:root_password', 'somepass') %}
{%- set mysql_host = salt['pillar.get']('mysql:server:host', 'localhost') %}

{% set user_states = [] %}
{% set user_hosts = [] %}

include:
  - mysql.python

{% for name, user in salt['pillar.get']('mysql:user', {}).items() %}

{% set user_host = salt['pillar.get']('mysql:user:%s:host'|format(name)) %}
{% if user_host != '' %}
  {% set user_hosts = [user_host] %}
{% else %}
  {% set user_hosts = salt['pillar.get']('mysql:user:%s:hosts'|format(name)) %}
{% endif %}

{% for host in user_hosts %}

{% set state_id = 'mysql_user_' ~ name ~ '_' ~ host%}
{{ state_id }}:
  mysql_user.present:
    - name: {{ name }}
    - host: '{{ host }}'
  {%- if user['password_hash'] is defined %}
    - password_hash: '{{ user['password_hash'] }}'
  {%- elif user['password'] is defined and user['password'] != None %}
    - password: '{{ user['password'] }}'
  {%- else %}
    - allow_passwordless: True
  {%- endif %}
    - connection_host: '{{ mysql_host }}'
    - connection_user: root
    {% if mysql_root_pass %}
    - connection_pass: '{{ mysql_root_pass }}'
    {% endif %}
    - connection_charset: utf8

{% for db in user['databases'] %}
{{ state_id ~ '_' ~ loop.index0 }}:
  mysql_grants.present:
    - name: {{ name ~ '_' ~ db['database']  ~ '_' ~ db['table'] | default('all') }}
    - grant: {{db['grants']|join(",")}}
    - database: '{{ db['database'] }}.{{ db['table'] | default('*') }}'
    - grant_option: {{ db['grant_option'] | default(False) }}
    - user: {{ name }}
    - host: '{{ host }}'
    - connection_host: '{{ mysql_host }}'
    - connection_user: root
    {% if mysql_root_pass -%}
    - connection_pass: '{{ mysql_root_pass }}'
    {% endif %}
    - connection_charset: utf8
    - require:
      - mysql_user: {{ name }}
{% endfor %}

{% do user_states.append(state_id) %}
{% endfor %}
{% endfor %}
