include:
  - .config
  - .python

{% from tpldir ~ "/map.jinja" import mysql with context %}

{%- set os = salt['grains.get']('os', None) %}
{%- set os_family = salt['grains.get']('os_family', None) %}
{%- set mysql_root_user = salt['pillar.get']('mysql:server:root_user', 'root') %}
{%- set mysql_root_password = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}
{%- set mysql_host = salt['pillar.get']('mysql:server:host', 'localhost') %}
{%- set mysql_salt_user = salt['pillar.get']('mysql:salt_user:salt_user_name', mysql_root_user) %}
{%- set mysql_salt_password = salt['pillar.get']('mysql:salt_user:salt_user_password', mysql_root_password) %}
{%- set mysql_datadir = salt['pillar.get']('mysql:server:mysqld:datadir', '/var/lib/mysql') %}
{%- set mysql_unix_socket = salt['pillar.get']('mysql:server:unix_socket', '') %}
{%- set lsb_distrib_codename = salt['grains.get']('lsb_distrib_codename', None) %}

{%- if mysql_root_password %}
{%-   if os_family == 'Debian' %}

{%-     if 'debconf_root_password' in mysql %}
{%-       set debconf_root_password = mysql.debconf_root_password %}
{%-       set debconf_root_password_again = mysql.debconf_root_password_again %}
{%-     elif mysql.serverpkg.startswith('percona-server-server') %}
{%-       if mysql.serverpkg < 'percona-server-server-5.7' %}{# 5.5 and 5.6 uses the same name... #}
{%-         set debconf_root_password = 'percona-server-server/root_password' %}
{%-         set debconf_root_password_again = 'percona-server-server/root_password_again' %}
{%-       elif '5.7' in mysql.serverpkg %}{# 5.7 changed option name... #}
{%-         set debconf_root_password = 'percona-server-server-5.7/root-pass' %}
{%-         set debconf_root_password_again = 'percona-server-server-5.7/re-root-pass' %}
{%-       else %}{# attempt to support future version? #}
{%-         set debconf_root_password = mysql.serverpkg + '/root-pass' %}
{%-         set debconf_root_password_again = mysql.serverpkg + '/re-root-pass' %}
{%-       endif %}
{%-     else %}
{%-       if salt['grains.get']('osmajorrelease')|int < 9 or not salt['grains.get']('os')|lower == 'debian' %}
{%-         set debconf_root_password = 'mysql-server/root_password' %}
{%-         set debconf_root_password_again = 'mysql-server/root_password_again' %}
{%-       else %}
{%-         set debconf_root_password = False %}
{%-       endif %}
{%-     endif %}

{%    if mysql.serverpkg == 'mysql-community-server' %}
mysql-community-server_repo:
  pkgrepo.managed:
    - humanname: "Mysql official repo"
    - name: deb http://repo.mysql.com/apt/ubuntu/ {{ lsb_distrib_codename }} mysql-8.0
    - file: /etc/apt/sources.list.d/mysql.list
    - refresh: True
    - require_in:
      - pkg: mysql-community-server
{%    endif %}

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

{%-   if debconf_root_password %}
{%      if mysql.serverpkg == 'mysql-community-server' %}
mysql_password_debconf:
  debconf.set:
    - name: 'mysql-community-server'
    - data:
        'mysql-community-server/root-pass': {'type': 'password', 'value': '{{ mysql_root_password }}'}
        'mysql-community-server/re-root-pass': {'type': 'password', 'value': '{{ mysql_root_password }}'}
        'mysql-server/default-auth-override': {'type': 'string', 'value':'Use Legacy Authentication Method (Retain MySQL 5.x Compatibility)'}
    - require_in:
      - pkg: {{ mysql.serverpkg }}
    - require:
      - pkg: mysql_debconf_utils
{%      else %}
mysql_password_debconf:
  debconf.set:
    - name: mysql-server
    - data:
        {{ debconf_root_password }}: {'type': 'password', 'value': '{{ mysql_root_password }}'}
        {{ debconf_root_password_again }}: {'type': 'password', 'value': '{{ mysql_root_password }}'}
    - prereq:
      - pkg: {{ mysql.serverpkg }}
    - require:
      - pkg: mysql_debconf_utils

{%      endif %}
{%    endif %}

{%-   elif os_family in ['RedHat', 'Suse', 'FreeBSD'] %}
mysql_root_password:
  cmd.run:
    - name: mysqladmin --host "{{ mysql_host }}" --user {{ mysql_root_user }} password '{{ mysql_root_password|replace("'", "'\"'\"'") }}'
    - unless: mysql --host "{{ mysql_host }}" --user {{ mysql_root_user }} --password='{{ mysql_root_password|replace("'", "'\"'\"'") }}' --execute="SELECT 1;"
    - require:
      - service: mysqld-service-running

{%-     for host in {'localhost': '', 'localhost.localdomain': '', salt['grains.get']('fqdn'): ''}.keys() %}
mysql_delete_anonymous_user_{{ host }}:
  mysql_user:
    - absent
    - host: {{ host or "''" }}
    - name: ''
    - connection_host: '{{ mysql_host }}'
    - connection_user: '{{ mysql_salt_user }}'
{%-       if mysql_salt_password %}
    - connection_pass: '{{ mysql_salt_password }}'
{%-       endif %}
{%-       if mysql_unix_socket %}
    - connection_unix_socket: '{{ mysql_unix_socket }}'
{%-       endif %}
    - connection_charset: utf8
    - require:
      - service: mysqld-service-running
      - pkg: mysql_python
{%-       if (mysql_salt_user == mysql_root_user) and mysql_root_password %}
      - cmd: mysql_root_password
{%-       endif %}
{%-       if (mysql_salt_user != mysql_root_user) %}
      - sls: mysql.salt-user
{%-       endif %}
{%-     endfor %}
{%-   endif %}
{%- endif %}

{%- if os_family == 'Arch' %}
# on arch linux: inital mysql datadirectory is not created
mysql_install_datadir:
  cmd.run:
{%-   if mysql.version is defined and mysql.version >= 5.7 %}
    - name: mysqld --initialize-insecure --user=mysql --basedir=/usr --datadir={{ mysql_datadir }}
{%-   else %}
    - name: mysql_install_db --user=mysql --basedir=/usr --datadir={{ mysql_datadir }}
{%-   endif %}
    - runas: root
    - creates: {{ mysql_datadir }}/mysql/user.frm
    - env:
        - TMPDIR: '/tmp'
    - require:
      - pkg: {{ mysql.serverpkg }}
      - file: mysql_config
    - require_in:
      - service: mysqld-service-running
{%- endif %}

mysqld-packages:
  pkg.installed:
    - name: {{ mysql.serverpkg }}
{%- if os_family == 'Debian' and mysql_root_password %}
    - require:
      - debconf: mysql_debconf
{%- endif %}
    - require_in:
      - file: mysql_config
{%- if "config_directory" in mysql %}
      - file: mysql_config_directory
{%- endif %}

{%- if os_family in ['RedHat', 'Suse'] and mysql.version is defined
      and mysql.version >= 5.7 and mysql.serverpkg.lower() != 'mariadb-server' %}
# Initialize mysql database with --initialize-insecure option before starting service so we don't get locked out.
mysql_initialize:
  cmd.run:
    - name: mysqld --initialize-insecure --user=mysql --basedir=/usr --datadir={{ mysql_datadir }}
    - runas: root
    - creates: {{ mysql_datadir }}/mysql/
    - require:
      - pkg: {{ mysql.serverpkg }}
{%- endif %}

{%- if os_family in ['RedHat', 'Suse'] and mysql.serverpkg.lower() == 'mariadb-server' %}
# For MariaDB it's enough to only create the datadir
mysql_initialize:
  file.directory:
    - name: {{ mysql_datadir }}
    - user: mysql
    - group: mysql
    - makedirs: True
    - require:
      - pkg: {{ mysql.serverpkg }}
{%- endif %}

{%- if os_family in ['Gentoo'] %}
mysql_initialize:
  cmd.run:
    - name: emerge --config {{ mysql.serverpkg }}
    - runas: root
    - creates: {{ mysql_datadir }}/mysql/
    - require:
      - pkg: {{ mysql.serverpkg }}
{%- endif %}

{%- if os_family in ['FreeBSD'] and mysql.serverpkg.lower() != 'mariadb-server' %}
mysql_initialize:
  file.directory:
    - name: /var/log/mysql
    - user: mysql
    - group: mysql
    - mode: '0750'
  cmd.run:
    - name: /usr/local/libexec/mysqld --initialize-insecure --user=mysql --basedir=/usr/local --datadir={{ mysql_datadir }}
    - runas: root
    - creates: {{ mysql_datadir }}/mysql/
    - require:
      - pkg: {{ mysql.serverpkg }}
      - file: /var/log/mysql
{%- endif %}

mysqld-service-running:
  service.running:
    - name: {{ mysql.service }}
    - enable: True
    - require:
      - pkg: {{ mysql.serverpkg }}
{%- if (os_family in ['RedHat', 'Suse'] and mysql.version is defined
      and mysql.version >= 5.7 and mysql.serverpkg.lower() != 'mariadb-server')
      or (os_family in ['Gentoo', 'FreeBSD']) %}
      - cmd: mysql_initialize
{%- elif os_family in ['RedHat', 'Suse'] and mysql.serverpkg.lower() == 'mariadb-server' %}
      - file: {{ mysql_datadir }}
{%- endif %}
    - watch:
      - pkg: {{ mysql.serverpkg }}
      - file: mysql_config
{%- if "config_directory" in mysql and "server_config" in mysql %}
      - file: mysql_server_config
{%- endif %}

mysql_what_is_status_of_{{ mysql.service }}:
  cmd.run:
    - names:
      - service {{ mysql.service }} status
    - onfail:
      - service: mysqld-service-running

# official oracle mysql repo
# creates this file, that rewrites /etc/mysql/my.cnf setting
# so, make it empty
mysql_additional_config:
  file.managed:
    - name: /usr/my.cnf
    - source: salt://{{ tpldir }}/files/usr-my.cnf
    - create: False
    - watch_in:
      - service: mysqld-service-running
