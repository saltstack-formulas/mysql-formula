{% from 'mysql/database.sls' import db_states with context %}
{% from 'mysql/user.sls' import user_states with context %}

{% macro requisites(type, states) %}
      {%- for state in states %}
        - {{ type }}: {{ state }}
      {%- endfor -%}
{% endmacro %}

include:
  - mysql.server
  - mysql.database
  - mysql.user

{% if (db_states|length() + user_states()) > 0 %}
extend:
  mysqld:
    service:
      - require_in:
        {{ requisites(db_states) }}
        {{ requisites(user_states) }}
  {% for state in user_states %}
  {{ state }}:
    mysql_user:
      - require:
        sls: mysql.database
  {% endfor %}
{% endif %}
    
