{%- set saltpath = salt['grains.get']('saltpath') -%}

{% if "/opt/saltstack/salt" in saltpath %}
mysqlclient_packages:
  pkg.installed:
    - pkgs:
      - libmariadb-dev
      - pkg-config

mysqlclient:
  pip.installed:
    - require:
      - pkg: mysqlclient_packages
{% else %}

{%- from tpldir ~ "/map.jinja" import mysql with context %}

mysql_python:
  pkg.installed:
    - name: {{ mysql.pythonpkg }}
    - reload_modules: True
{% endif %}
