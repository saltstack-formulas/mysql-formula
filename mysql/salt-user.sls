include:
  - mysql.server

{% set os_family = salt['grains.get']('os_family', None) %}
{% set mysql_salt_user = salt['pillar.get']('mysql:salt_user:salt_user_name', 'salt') %}
{% set mysql_salt_pass = salt['pillar.get']('mysql:salt_user:salt_user_password', salt['grains.get']('server_id')) %}
{% set mysql_salt_grants = salt['pillar.get']('mysql:salt_user:grants', []) %}
{% set mysql_root_user = salt['pillar.get']('mysql:server:root_user', 'root') %}
{% set mysql_root_pass = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}
{% set mysql_root_hash = salt['pillar.get']('mysql:server:root_password_hash', None) %}

{% set mysql_host = salt['pillar.get']('mysql:server:host', 'localhost') %}
{% if mysql_host == 'localhost' %}
{% set host = 'localhost' %}
{% else %}
{% set host = grains['fqdn'] %}
{% endif %}

mysql_salt_user_with_salt_user:
  mysql_user.present:
    - name: {{ mysql_salt_user }}
    - host: '{{ host }}'
    - password: '{{ mysql_salt_pass }}'
    - connection_host: '{{ mysql_host }}'
    - connection_user: '{{ mysql_salt_user }}'
    - connection_pass: '{{ mysql_salt_pass }}'
    - connection_charset: utf8
    - onlyif:
      - mysql --user {{ mysql_salt_user }} --password='{{ mysql_salt_pass|replace("'", "'\"'\"'") }}' -h {{ mysql_host }} --execute="SELECT 1;"
      - VALUE=$(mysql --user {{ mysql_salt_user }} --password='{{ mysql_salt_pass|replace("'", "'\"'\"'") }}' -ss -e "SELECT Grant_priv FROM mysql.user WHERE user = '{{ mysql_salt_user }}' AND host = '{{ host }}';"); if [ "$VALUE" = 'Y' ]; then /bin/true; else /bin/false; fi
{% if os_family in ['RedHat', 'Suse'] %}
    - require_in:
      - mysql_user: mysql_root_password
{% endif %}

{%- if mysql_salt_grants != [] %}
mysql_salt_user_with_salt_user_grants:
  mysql_grants.present:
    - name: {{ mysql_salt_user }}
    - grant: {{ mysql_salt_grants|join(",") }}
    - database: '*.*'
    - grant_option: True
    - user: {{ mysql_salt_user }}
    - host: '{{ host }}'
    - connection_host: '{{ mysql_host }}'
    - connection_user: '{{ mysql_salt_user }}'
    - connection_pass: '{{ mysql_salt_pass }}'
    - connection_charset: utf8
    - onlyif:
      - mysql --user {{ mysql_salt_user }} --password='{{ mysql_salt_pass|replace("'", "'\"'\"'") }}' -h {{ mysql_host }} --execute="SELECT 1;"
      - VALUE=$(mysql --user {{ mysql_salt_user }} --password='{{ mysql_salt_pass|replace("'", "'\"'\"'") }}' -ss -e "SELECT Grant_priv FROM mysql.user WHERE user = '{{ mysql_salt_user }}' AND host = '{{ host }}';"); if [ "$VALUE" = 'Y' ]; then /bin/true; else /bin/false; fi
    - require:
      - mysql_user: mysql_salt_user_with_salt_user
{% if os_family in ['RedHat', 'Suse'] %}
    - require_in:
      - mysql_user: mysql_root_password
{% endif %}
{% endif %}

mysql_salt_user_with_root_user:
  mysql_user.present:
    - name: {{ mysql_salt_user }}
    - host: '{{ host }}'
    - password: '{{ mysql_salt_pass }}'
    - connection_host: '{{ mysql_host }}'
    - connection_user: '{{ mysql_root_user }}'
    - connection_pass: '{{ mysql_root_pass }}'
    - connection_charset: utf8
    - onlyif:
      - mysql --user {{ mysql_root_user }} --password='{{ mysql_root_pass|replace("'", "'\"'\"'") }}' -h {{ mysql_host }} --execute="SELECT 1;"
      - VALUE=$(mysql --user {{ mysql_root_user }} --password='{{ mysql_root_pass|replace("'", "'\"'\"'") }}' -ss -e "SELECT Grant_priv FROM mysql.user WHERE user = '{{ mysql_salt_user }}' AND host = '{{ host }}';"); if [ "$VALUE" = 'N' -o -z "$VALUE" ]; then /bin/true; else /bin/false; fi
{% if os_family in ['RedHat', 'Suse'] %}
    - require_in:
      - mysql_user: mysql_root_password
{% endif %}

{%- if mysql_salt_grants != [] %}
mysql_salt_user_with_root_user_grants:
  mysql_grants.present:
    - name: {{ mysql_salt_user }}
    - grant: {{ mysql_salt_grants|join(",") }}
    - database: '*.*'
    - grant_option: True
    - user: {{ mysql_salt_user }}
    - host: '{{ host }}'
    - connection_host: '{{ mysql_host }}'
    - connection_user: '{{ mysql_root_user }}'
    - connection_pass: '{{ mysql_root_pass }}'
    - connection_charset: utf8
    - onlyif:
      - mysql --user {{ mysql_root_user }} --password='{{ mysql_root_pass|replace("'", "'\"'\"'") }}' -h {{ mysql_host }} --execute="SELECT 1;"
      - VALUE=$(mysql --user {{ mysql_root_user }} --password='{{ mysql_root_pass|replace("'", "'\"'\"'") }}' -ss -e "SELECT Grant_priv FROM mysql.user WHERE user = '{{ mysql_salt_user }}' AND host = '{{ host }}';"); if [ "$VALUE" = 'N' -o -z "$VALUE" ]; then /bin/true; else /bin/false; fi
    - require:
      - mysql_user: mysql_salt_user_with_root_user
{% if os_family in ['RedHat', 'Suse'] %}
    - require_in:
      - mysql_user: mysql_root_password
{% endif %}
{% endif %}

mysql_salt_user_with_passwordless_root_user:
  mysql_user.present:
    - name: {{ mysql_salt_user }}
    - host: '{{ host }}'
    - password: '{{ mysql_salt_pass }}'
    - connection_host: '{{ mysql_host }}'
    - connection_user: '{{ mysql_root_user }}'
    - connection_charset: utf8
    - onlyif:
      - mysql --user {{ mysql_root_user }} -h {{ mysql_host }} --execute="SELECT 1;"
      - VALUE=$(mysql --user {{ mysql_root_user }} -ss -e "SELECT Grant_priv FROM mysql.user WHERE user = '{{ mysql_salt_user }}' AND host = '{{ host }}';"); if [ "$VALUE" = 'N' -o -z "$VALUE" ]; then /bin/true; else /bin/false; fi
{% if os_family in ['RedHat', 'Suse'] %}
    - require_in:
      - mysql_user: mysql_root_password
{% endif %}

{%- if mysql_salt_grants != [] %}
mysql_salt_user_with_passwordless_root_user_grants:
  mysql_grants.present:
    - name: {{ mysql_salt_user }}
    - grant: {{ mysql_salt_grants|join(",") }}
    - database: '*.*'
    - grant_option: True
    - user: {{ mysql_salt_user }}
    - host: '{{ host }}'
    - connection_host: '{{ mysql_host }}'
    - connection_user: '{{ mysql_root_user }}'
    - connection_charset: utf8
    - onlyif:
      - mysql --user {{ mysql_root_user }} -h {{ mysql_host }} --execute="SELECT 1;"
      - VALUE=$(mysql --user {{ mysql_root_user }} -ss -e "SELECT Grant_priv FROM mysql.user WHERE user = '{{ mysql_salt_user }}' AND host = '{{ host }}';"); if [ "$VALUE" = 'N' -o -z "$VALUE" ]; then /bin/true; else /bin/false; fi
    - require:
      - mysql_user: mysql_salt_user_with_passwordless_root_user
{% if os_family in ['RedHat', 'Suse'] %}
    - require_in:
      - mysql_user: mysql_root_password
{% endif %}
{% endif %}

{% if os_family in ['RedHat', 'Suse'] %}
extend:
  mysql_root_password:
    cmd.run:
      - name: /bin/true
      - unless: /bin/true
    mysql_user.present:
      - name: {{ mysql_root_user }}
      - host: 'localhost'
      {%- if mysql_root_hash != None %}
      - password_hash: '{{ mysql_root_hash }}'
      {%- elif mysql_root_pass != None %}
      - password: '{{ mysql_root_pass }}'
      {%- else %}
      - allow_passwordless: True
      {%- endif %}
      - connection_host: '{{ mysql_host }}'
      - connection_user: '{{ mysql_salt_user }}'
      - connection_pass: '{{ mysql_salt_pass }}'
      - connection_charset: utf8
{% endif %}
