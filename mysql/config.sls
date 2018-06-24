{% from tpldir ~ "/map.jinja" import mysql with context %}
{% set os_family = salt['grains.get']('os_family', None) %}

{% if "config_directory" in mysql %}
mysql_config_directory:
  file.directory:
    - name: {{ mysql.config_directory }}
    {% if os_family in ['Debian', 'Gentoo', 'RedHat'] %}
    - user: root
    - group: root
    - mode: 755
    {% endif %}
    - makedirs: True

{% if "server_config" in mysql %}
mysql_server_config:
  file.managed:
    - name: {{ mysql.config_directory + mysql.server_config.file }}
    - template: jinja
    - source: salt://{{ tpldir }}/files/server.cnf
    {% if os_family in ['Debian', 'Gentoo', 'RedHat'] %}
    - context:
      tpldir: {{ tpldir }}
    - user: root
    - group: root
    - mode: 644
    {% endif %}
{% endif %}

{% if "galera_config" in mysql %}
mysql_galera_config:
  file.managed:
    - name: {{ mysql.config_directory + mysql.galera_config.file }}
    - template: jinja
    - source: salt://{{ tpldir }}/files/galera.cnf
    {% if os_family in ['Debian', 'Gentoo', 'RedHat'] %}
    - context:
      tpldir: {{ tpldir }}
    - user: root
    - group: root
    - mode: 644
    {% endif %}
{% endif %}

{% if "library_config" in mysql %}
mysql_library_config:
  file.managed:
    - name: {{ mysql.config_directory + mysql.library_config.file }}
    - template: jinja
    - source: salt://{{ tpldir }}/files/client.cnf
    {% if os_family in ['Debian', 'Gentoo', 'RedHat'] %}
    - context:
      tpldir: {{ tpldir }}
    - user: root
    - group: root
    - mode: 644
    {% endif %}
{% endif %}

{% if "clients_config" in mysql %}
mysql_clients_config:
  file.managed:
    - name: {{ mysql.config_directory + mysql.clients_config.file }}
    - template: jinja
    - source: salt://{{ tpldir }}/files/mysql-clients.cnf
    {% if os_family in ['Debian', 'Gentoo', 'RedHat'] %}
    - context:
      tpldir: {{ tpldir }}
    - user: root
    - group: root
    - mode: 644
    {% endif %}
{% endif %}

{% endif %}

mysql_config:
  file.managed:
    - name: {{ mysql.config.file }}
    - template: jinja
{% if "config_directory" in mysql %}
    - source: salt://{{ tpldir }}/files/my-include.cnf
{% else %}
    - source: salt://{{ tpldir }}/files/my.cnf
{% endif %}
    - context:
      tpldir: {{ tpldir }}
    {% if os_family in ['Debian', 'Gentoo', 'RedHat'] %}
    - user: root
    - group: root
    - mode: 644
    {% endif %}
