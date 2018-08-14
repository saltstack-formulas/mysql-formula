include:
  - .config
  - .python

{% from tpldir ~ "/map.jinja" import mysql with context %}

{% set os = salt['grains.get']('os', None) %}
{% set os_family = salt['grains.get']('os_family', None) %}
{% set mysql_root_user = salt['pillar.get']('mysql:server:root_user', 'root') %}
{% set mysql_root_password = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}
{% set mysql_host = salt['pillar.get']('mysql:server:host', 'localhost') %}
{% set mysql_salt_user = salt['pillar.get']('mysql:salt_user:salt_user_name', mysql_root_user) %}
{% set mysql_salt_password = salt['pillar.get']('mysql:salt_user:salt_user_password', mysql_root_password) %}
{% set mysql_datadir = salt['pillar.get']('mysql:server:mysqld:datadir', '/var/lib/mysql') %}

{% if mysql_root_password %}
{% if os_family == 'Debian' %}
mysql_debconf_utils:
  pkg.installed:
    - name: {{ mysql.debconf_utils }}

mysql_debconf:
  debconf.set:
    - name: {{ mysql.serverpkg }}
    - data:
        '{{ mysql.serverpkg }}/start_on_boot': {'type': 'boolean', 'value': 'true'}
    - require_in:
      - pkg: {{ mysql.serverpkg }}
    - require:
      - pkg: mysql_debconf_utils

{% if salt['grains.get']('osmajorrelease')|int < 9 or not salt['grains.get']('os')|lower == 'debian' %}
mysql_password_debconf:
  debconf.set:
    - name: mysql-server
    - data:
        'mysql-server/root_password': {'type': 'password', 'value': '{{ mysql_root_password }}'}
        'mysql-server/root_password_again': {'type': 'password', 'value': '{{ mysql_root_password }}'}
    - require_in:
      - pkg: {{ mysql.serverpkg }}
    - require:
      - pkg: mysql_debconf_utils
{% endif %}

{% elif os_family in ['RedHat', 'Suse', 'FreeBSD'] %}
mysql_root_password:
  cmd.run:
    - name: mysqladmin --host "{{ mysql_host }}" --user {{ mysql_root_user }} password '{{ mysql_root_password|replace("'", "'\"'\"'") }}'
    - unless: mysql --host "{{ mysql_host }}" --user {{ mysql_root_user }} --password='{{ mysql_root_password|replace("'", "'\"'\"'") }}' --execute="SELECT 1;"
    - require:
      - service: mysqld

{% for host in {'localhost': '', 'localhost.localdomain': '', salt['grains.get']('fqdn'): ''}.keys() %}
mysql_delete_anonymous_user_{{ host }}:
  mysql_user:
    - absent
    - host: {{ host or "''" }}
    - name: ''
    - connection_host: '{{ mysql_host }}'
    - connection_user: '{{ mysql_salt_user }}'
    {% if mysql_salt_password %}
    - connection_pass: '{{ mysql_salt_password }}'
    {% endif %}
    - connection_charset: utf8
    - require:
      - service: mysqld
      - pkg: mysql_python
      {%- if (mysql_salt_user == mysql_root_user) and mysql_root_password %}
      - cmd: mysql_root_password
      {%- endif %}
      {%- if (mysql_salt_user != mysql_root_user) %}
      - sls: mysql.salt-user
      {%- endif %}
{% endfor %}
{% endif %}
{% endif %}

{% if os_family == 'Arch' %}
# on arch linux: inital mysql datadirectory is not created
mysql_install_datadir:
  cmd.run:
{% if mysql.version is defined and mysql.version >= 5.7 %}
    - name: mysqld --initialize-insecure --user=mysql --basedir=/usr --datadir={{ mysql_datadir }}
{% else %}
    - name: mysql_install_db --user=mysql --basedir=/usr --datadir={{ mysql_datadir }}
{% endif %}
    - user: root
    - creates: {{ mysql_datadir }}/mysql/user.frm
    - env:
        - TMPDIR: '/tmp'
    - require:
      - pkg: {{ mysql.serverpkg }}
      - file: mysql_config
    - require_in:
      - service: mysqld
{% endif %}

mysqld-packages:
  pkg.installed:
    - name: {{ mysql.serverpkg }}
{% if os_family == 'Debian' and mysql_root_password %}
    - require:
      - debconf: mysql_debconf
{% endif %}
    - require_in:
      - file: mysql_config

{% if os_family in ['RedHat', 'Suse'] and mysql.version is defined and mysql.version >= 5.7 and mysql.serverpkg != 'mariadb-server' %}
# Initialize mysql database with --initialize-insecure option before starting service so we don't get locked out.
mysql_initialize:
  cmd.run:
    - name: mysqld --initialize-insecure --user=mysql --basedir=/usr --datadir={{ mysql_datadir }}
    - user: root
    - creates: {{ mysql_datadir}}/mysql/
    - require:
      - pkg: {{ mysql.serverpkg }}
{% endif %}

{% if os_family in ['RedHat', 'Suse'] and mysql.serverpkg == 'mariadb-server' %}
# For MariaDB it's enough to only create the datadir
mysql_initialize:
  file.directory:
    - name: {{ mysql_datadir }}
    - user: mysql
    - group: mysql
    - makedirs: True
    - require:
      - pkg: {{ mysql.serverpkg }}
{% endif %}

{% if os_family in ['Gentoo'] %}
mysql_initialize:
  cmd.run:
    - name: emerge --config {{ mysql.serverpkg }}
    - user: root
    - creates: {{ mysql_datadir}}/mysql/
    - require:
      - pkg: {{ mysql.serverpkg }}
{% endif %}

mysqld:
  service.running:
    - name: {{ mysql.service }}
    - enable: True
    - require:
      - pkg: {{ mysql.serverpkg }}
{% if (os_family in ['RedHat', 'Suse'] and mysql.version is defined and mysql.version >= 5.7 and mysql.serverpkg != 'mariadb-server') or (os_family in ['Gentoo']) %}
      - cmd: mysql_initialize
{% elif os_family in ['RedHat', 'Suse'] and mysql.serverpkg == 'mariadb-server' %}
      - file: {{ mysql_datadir }}
{% endif %}
    - watch:
      - pkg: {{ mysql.serverpkg }}
      - file: mysql_config
{% if "config_directory" in mysql and "server_config" in mysql %}
      - file: mysql_server_config
{% endif %}

# official oracle mysql repo
# creates this file, that rewrites /etc/mysql/my.cnf setting
# so, make it empty
mysql_additional_config:
  file.managed:
    - name: /usr/my.cnf
    - source: salt://{{ tpldir }}/files/usr-my.cnf
    - create: False
    - watch_in:
      - service: mysqld
