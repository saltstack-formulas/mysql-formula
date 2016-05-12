# vim: set ft=yaml:

include:
  - mysql

{% from 'mysql/database.sls' import db_states with context %}
{% from 'mysql/user.sls' import user_states with context %}

{% macro requisites(type, states) %}
      {%- for state in states %}
        - {{ type }}: {{ state }}
      {%- endfor -%}
{% endmacro %}

#mariadb_repo:
#  pkgrepo.managed:
#    - humanname: MariaDB
#    - name: deb http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.1/debian wheezy main
#    - dist: wheezy
#    - file: /etc/apt/sources.list.d/MariaDB.list
#    - keyid: '0xcbcb082a1bb943db'
#    - keyserver: keyserver.ubuntu.com
#    - require_in:
#      - pkg: mysqld

mariadb_root_password:
  mysql_user.present:
    - name: root
    - host: localhost
    - password: {{ salt['pillar.get']('mysql:server:root_password') }}
    - connection_pass: ""
    - require:
      - service: mysqld
    - require_in:
      {{ requisites('mysql_database', db_states) }}
      {{ requisites('mysql_user', user_states) }}

# Don't write out my.cnf or do debconf
# @todo Consider debconf for MariaDB:
#   http://dba.stackexchange.com/questions/35866/install-mariadb-without-password-prompt-in-ubuntu
extend:
  mysql_config:
    file.managed:
      - unless:
        - echo
  #mysql_debconf:
  #  debconf.set:
  #    - unless:
  #      - echo
