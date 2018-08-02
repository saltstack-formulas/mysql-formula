{% from tpldir ~ '/database.sls' import db_states with context %}
{% from tpldir ~ '/user.sls' import user_states with context %}

{% macro requisites(type, states) %}
      {%- for state in states %}
        - {{ type }}: {{ state }}
      {%- endfor -%}
{% endmacro %}

{% set mysql_dev = salt['pillar.get']('mysql:dev:install', False) %}
{% set mysql_salt_user = salt['pillar.get']('mysql:salt_user:salt_user_name', False) %}

include:
  - .server
{% if mysql_salt_user %}
  - .salt-user
{% endif %}
  - .database
  - .user
{% if mysql_dev %}
  - .dev
{% endif %}


{% if (db_states|length() + user_states|length()) > 0 %}
extend:
  mysqld:
    service:
      - require_in:
        {{ requisites('mysql_database', db_states) }}
        {{ requisites('mysql_user', user_states) }}
{% endif %}
