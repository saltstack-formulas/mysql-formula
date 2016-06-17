{% from 'mysql/database.sls' import db_states with context %}
{% from 'mysql/user.sls' import user_states with context %}

{% macro requisites(type, states) %}
      {%- for state in states %}
        - {{ type }}: {{ state }}
      {%- endfor -%}
{% endmacro %}

{% set mysql_dev = salt['pillar.get']('mysql:dev:install', False) %}

include:
  - mysql.server
  - mysql.database
  - mysql.user
{% if mysql_dev %}
  - mysql.dev
{% endif %}
{% if salt['pillar.get']('mysql:server:enable_root_my_cnf', False) %}
  - mysql.change_root_password
{% endif %}


{% if (db_states|length() + user_states|length()) > 0 %}
extend:
  mysqld:
    service:
      - require_in:
        {{ requisites('mysql_database', db_states) }}
        {{ requisites('mysql_user', user_states) }}
{% endif %}
