{%- from tpldir ~ "/map.jinja" import mysql with context %}

{%- set mysql_root_user = salt['pillar.get']('mysql:server:root_user', 'root') %}
{%- set mysql_root_pass = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}
{%- set mysql_host = salt['pillar.get']('mysql:server:host', 'localhost') %}
{%- set mysql_salt_user = salt['pillar.get']('mysql:salt_user:salt_user_name', mysql_root_user) %}
{%- set mysql_salt_pass = salt['pillar.get']('mysql:salt_user:salt_user_password', mysql_root_pass) %}
{%- set mysql_unix_socket = mysql.config.sections.mysqld.socket %}

include:
  - .python
  - .server

mysql remove test database:
  mysql_database.absent:
    - name: test
    - host: '{{ mysql_host }}'
    - connection_user: '{{ mysql_salt_user }}'
    - connection_host: '{{ mysql_host }}'
    {%- if mysql_salt_pass %}
    - connection_pass: '{{ mysql_salt_pass }}'
    {%- endif %}
    - connection_charset: utf8
    {%- if mysql_unix_socket %}
    - connection_unix_socket: '{{ mysql_unix_socket }}'
    {%- endif %}
    - require:
      - service: mysqld-service-running
