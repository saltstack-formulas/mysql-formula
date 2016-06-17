# vim: set ft=jinja:
#
# Mysql - MariaDB formula for changing root password.
#
# Note: as root password is required to changed root password for mysql
#       (without restarting the server with  --skip-grant-tables) this formula require .my.cnf
#       See: root_my_cnf.sls
#       Other magical case are not handled.
#
# The previous password must be stored in ~/.my.cnf (even empty)
# See: root_my_cnf.sls

# TODO: DRY this bloc in a common file for every state
{% from "mysql/defaults.yaml" import rawmap with context %}
{%- set mysql = salt['grains.filter_by'](rawmap, grain='os', merge=salt['pillar.get']('mysql:lookup')) %}
{% set os = salt['grains.get']('os', None) %}
{% set os_family = salt['grains.get']('os_family', None) %}
{% set mysql_root_user = salt['pillar.get']('mysql:server:root_user', 'root') %}
{% set mysql_root_password = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}
{% set mysql_host = salt['pillar.get']('mysql:server:host', 'localhost') %}
{% set mysql_salt_user = salt['pillar.get']('mysql:salt_user:salt_user_name', mysql_root_user) %}
{% set mysql_salt_password = salt['pillar.get']('mysql:salt_user:salt_user_password', mysql_root_password) %}

# DONT do fancy password with double quote, nor starting or ending with space
{% set escaped_root_pass = mysql_root_password|replace("'", "''") %}
{% set my_cnf = '/root/.my.cnf' %}

# WARNING: no double quote in the query
{% set query = """
UPDATE user SET password = password('" ~ escaped_root_pass ~ "') WHERE user = 'root';
FLUSH PRIVILEGES;
""" %}
change_all_root_pass:
  cmd.run:
    - name: mysql --defaults-file={{ my_cnf }} -e "{{ query|replace("\n", '') }}" mysql
    - unless: grep -q "\<{{ escaped_root_pass }}$" {{ my_cnf }}
    - require_in:
      - file: mysql_root_my_cnf

# recreate /root/.my.cnf
include:
  - mysql.root_my_cnf
