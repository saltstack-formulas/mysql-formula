{% from "mysql/defaults.yaml" import rawmap with context %}
{%- set mysql = salt['grains.filter_by'](rawmap, grain='os', merge=salt['pillar.get']('mysql:lookup')) %}

{% set os = salt['grains.get']('os', None) %}
{% set os_family = salt['grains.get']('os_family', None) %}
{% set mysql_root_password = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}
{% set mysql_host = salt['pillar.get']('mysql:server:host', 'localhost') %}

{% if mysql_root_password %}
{% if os_family == 'Debian' %}
mysql_debconf_utils:
  pkg.installed:
    - name: {{ mysql.debconf_utils }}

mysql_debconf:
  debconf.set:
    - name: mysql-server
    - data:
        'mysql-server/root_password': {'type': 'password', 'value': '{{ mysql_root_password }}'}
        'mysql-server/root_password_again': {'type': 'password', 'value': '{{ mysql_root_password }}'}
        'mysql-server/start_on_boot': {'type': 'boolean', 'value': 'true'}
    - require_in:
      - pkg: mysqld
    - require:
      - pkg: mysql_debconf_utils
{% elif os_family == 'RedHat' %}
mysql_root_password:
  cmd.run:
    - name: mysqladmin --user root password '{{ mysql_root_password|replace("'", "'\"'\"'") }}'
    - unless: mysql --user root --password='{{ mysql_root_password|replace("'", "'\"'\"'") }}' --execute="SELECT 1;"
    - require:
      - service: mysqld

include:
  - mysql.python

{% for host in ['localhost', 'localhost.localdomain', salt['grains.get']('fqdn')] %}
mysql_delete_anonymous_user_{{ host }}:
  mysql_user:
    - absent
    - host: {{ host or "''" }}
    - name: ''
    - connection_host: '{{ mysql_host }}'
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_charset: utf8
    - require:
      - service: mysqld
      - pkg: mysql_python
      {%- if mysql_root_password %}
      - cmd: mysql_root_password
      {%- endif %}
{% endfor %}
{% endif %}
{% endif %}

mysqld:
  pkg.installed:
    - name: {{ mysql.server }}
{% if os_family == 'Debian' and mysql_root_password %}
    - require:
      - debconf: mysql_debconf
{% endif %}
  service.running:
    - name: {{ mysql.service }}
    - enable: True
    - watch:
      - pkg: mysqld

mysql_config:
  file.managed:
    - name: {{ mysql.config.file }}
    - template: jinja
    - source: salt://mysql/files/my.cnf
    - watch_in:
      - service: mysqld
    {% if os_family in ['Debian', 'Gentoo', 'RedHat'] %}
    - user: root
    - group: root
    - mode: 644
    {% endif %}

# official oracle mysql repo
# creates this file, that rewrites /etc/mysql/my.cnf setting
# so, make it empty
mysql_additional_config:
  file.managed:
    - name: /usr/my.cnf
    - source: salt://mysql/files/usr-my.cnf
    - create: False
    - watch_in:
      - service: mysqld
