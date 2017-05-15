{% from "mysql/defaults.yaml" import rawmap with context %}
{%- set mysql = salt['grains.filter_by'](rawmap, grain='os', merge=salt['pillar.get']('mysql:server:lookup')) %}
{%- set mysql_root_user = salt['pillar.get']('mysql:server:root_user', 'root') %}
{%- set mysql_root_pass = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}
{%- set mysql_host = salt['pillar.get']('mysql:server:host', 'localhost') %}
{% set mysql_salt_user = salt['pillar.get']('mysql:salt_user:salt_user_name', mysql_root_user) %}
{% set mysql_salt_pass = salt['pillar.get']('mysql:salt_user:salt_user_password', mysql_root_pass) %}

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

{% if not user_hosts %}
  {% set mine_target = salt['pillar.get']('mysql:user:%s:mine_hosts:target'|format(name)) %}
  {% set mine_function = salt['pillar.get']('mysql:user:%s:mine_hosts:function'|format(name)) %}
  {% set mine_expression_form = salt['pillar.get']('mysql:user:%s:mine_hosts:expr_form'|format(name)) %}

  {% if mine_target and mine_function and mine_expression_form %}
    {% set user_hosts = salt['mine.get'](mine_target, mine_function, mine_expression_form).values() %}
  {% endif %}
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
    - connection_user: '{{ mysql_salt_user }}'
    {% if mysql_salt_pass %}
    - connection_pass: '{{ mysql_salt_pass }}'
    {% endif %}
    - connection_charset: utf8

{%- if 'grants' in user %}
{{ state_id ~ '_grants' }}:
  mysql_grants.present:
    - name: {{ name }}
    - grant: {{ user['grants']|join(",") }}
    - database: '*.*'
    - grant_option: {{ user['grant_option'] | default(False) }}
    - user: {{ name }}
    - host: '{{ host }}'
    - connection_host: '{{ mysql_host }}'
    - connection_user: '{{ mysql_salt_user }}'
    {% if mysql_salt_pass -%}
    - connection_pass: '{{ mysql_salt_pass }}'
    {% endif %}
    - connection_charset: utf8
    - require:
      - mysql_user: {{ state_id }}
{% endif %}

{%- if 'databases' in user %}
{% for db in user['databases'] %}
{{ state_id ~ '_' ~ loop.index0 }}:
  mysql_grants.present:
    - name: {{ name ~ '_' ~ db['database']  ~ '_' ~ db['table'] | default('all') }}
    - grant: {{db['grants']|join(",")}}
    - database: '{{ db['database'] }}.{{ db['table'] | default('*') }}'
    - grant_option: {{ db['grant_option'] | default(False) }}
    {% if 'ssl' in user or 'ssl-X509' in user %}
    - ssl_option:
      - SSL: {{ user['ssl'] | default(False) }}
    {% if user['ssl-X509'] is defined %}
      - X509: {{ user['ssl-X509'] }}
    {% endif %}
    {% if user['ssl-SUBJECT'] is defined %}
      - SUBJECT: {{ user['ssl-SUBJECT'] }}
    {% endif %}
    {% if user['ssl-ISSUER'] is defined %}
      - ISSUER: {{ user['ssl-ISSUER'] }}
    {% endif %}
    {% if user['ssl-CIPHER'] is defined %}
      - CIPHER: {{ user['ssl-CIPHER'] }}
    {% endif %}
    {% endif %}
    - user: {{ name }}
    - host: '{{ host }}'
    - connection_host: '{{ mysql_host }}'
    - connection_user: '{{ mysql_salt_user }}'
    {% if mysql_salt_pass -%}
    - connection_pass: '{{ mysql_salt_pass }}'
    {% endif %}
    - connection_charset: utf8
    - require:
      - mysql_user: {{ state_id }}
{% endfor %}
{% endif %}

{% do user_states.append(state_id) %}
{% endfor %}
{% endfor %}
