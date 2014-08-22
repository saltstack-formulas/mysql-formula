{% from "mysql/map.jinja" import mysql with context %}

{% set os = salt['grains.get']('os', None) %}
{% set os_family = salt['grains.get']('os_family', None) %}
{% set mysql_root_password = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}

{% if os_family == 'Debian' %}
mysql_debconf:
  debconf.set:
    - name: mysql-server
    - data:
        'mysql-server/root_password': {'type': 'password', 'value': '{{ mysql_root_password }}'}
        'mysql-server/root_password_again': {'type': 'password', 'value': '{{ mysql_root_password }}'}
        'mysql-server/start_on_boot': {'type': 'boolean', 'value': 'true'}
    - require_in:
      - pkg: mysqld
{% elif os_family == 'RedHat' %}
mysql_root_password:
  cmd.run:
    - name: mysqladmin --user root password '{{ mysql_root_password|replace("'", "'\"'\"'") }}'
    - unless: mysql --user root --password='{{ mysql_root_password|replace("'", "'\"'\"'") }}' --execute="SELECT 1;"
    - require:
      - service: mysqld

{% for host in ['localhost', salt['grains.get']('fqdn')] %}
mysql_delete_anonymous_user_{{ host }}:
  mysql_user:
    - absent
    - host: {{ host }}
    - name: ''
    - connection_host: localhost
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

mysqld:
  pkg.installed:
    - name: {{ mysql.server }}
{% if os_family == 'Debian' %}
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
    - name: {{ mysql.config }}
    - template: jinja
    - watch_in:
      - service: mysqld
    {% if os_family in ['Debian', 'Gentoo', 'RedHat'] %}
    - source: salt://mysql/files/{{ os }}-my.cnf
    - user: root
    - group: root
    - mode: 644
    {% elif os == 'FreeBSD' %}
    - source: salt://mysql/files/my-{{ mysql.mysql_size }}.cnf
    {% endif %}
