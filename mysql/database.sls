{% from tpldir ~ "/map.jinja" import mysql with context %}

{% set mysql_root_user = salt['pillar.get']('mysql:server:root_user', 'root') %}
{% set mysql_root_pass = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}
{% set mysql_host = salt['pillar.get']('mysql:server:host', 'localhost') %}
{% set db_states = [] %}

{% set mysql_salt_user = salt['pillar.get']('mysql:salt_user:salt_user_name', mysql_root_user) %}
{% set mysql_salt_pass = salt['pillar.get']('mysql:salt_user:salt_user_password', mysql_root_pass) %}

include:
  - .python

{% for database_obj in salt['pillar.get']('mysql:database', []) %}
{% set state_id = 'mysql_db_' ~ loop.index0 %}
{% set database = database_obj.get('name') if database_obj is mapping else database_obj %}
{{ state_id }}:
  mysql_database.present:
    - name: {{ database }}
    - connection_host: '{{ mysql_host }}'
    - connection_user: '{{ mysql_salt_user }}'
    {% if mysql_salt_pass %}
    - connection_pass: '{{ mysql_salt_pass }}'
    {% endif %}
    {% if database_obj is mapping %}
    - character_set: {{ database_obj.get('character_set', '') }}
    - collate: {{ database_obj.get('collate', '') }}
    {% endif %}
    - connection_charset: utf8

{% if salt['pillar.get'](['mysql', 'schema', database, 'load']|join(':'), False) %}
{{ state_id }}_schema:
  file.managed:
    - name: /etc/mysql/{{ database }}.schema
    - source: {{ salt['pillar.get'](['mysql', 'schema', database, 'source']|join(':')) }}
{%- set template_type = salt['pillar.get'](['mysql', 'schema', database, 'template']|join(':'), False) %}
{%- set template_context = salt['pillar.get'](['mysql', 'schema', database, 'context']|join(':'), {}) %}
{%- if template_type %}
    - template: {{ template_type }}
    - context: {{ template_context|yaml }}
{% endif %}
    - user: {{ salt['pillar.get']('mysql:server:user', 'mysql') }}
    - makedirs: True

{{ state_id }}_load:
  cmd.wait:
    - name: mysql -u {{ mysql_salt_user }} -h{{ mysql_host }} {% if mysql_salt_pass %}-p{% endif %}{{ mysql_salt_pass }} {{ database }} < /etc/mysql/{{ database }}.schema
    - watch:
      - file: {{ state_id }}_schema
      - mysql_database: {{ state_id }}
{% endif %}

{% do db_states.append(state_id) %}
{% endfor %}
