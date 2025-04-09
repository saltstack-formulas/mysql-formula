{%- from tpldir ~ "/map.jinja" import mysql with context %}

mysqlclient_packages:
  pkg.installed:
    - pkgs:
      - libmariadb-dev
      - pkg-config
    - reload_modules: True

mysqlclient:
  pip.installed:
    - require:
      - pkg: mysqlclient_packages
