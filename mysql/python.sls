{%- from tpldir ~ "/map.jinja" import mysql with context %}

mysql_python:
  pkg.installed:
    - name: {{ mysql.pythonpkg }}
    - reload_modules: true

{% if grains['os'] in ['Ubuntu', 'Debian'] %}
mysqlclient-build-tools:
  pkg.installed:
    - pkgs:
      - build-essential
      - pkgconf # replaces pkg-config on Debian

mysqlclient-dev-pkg:
  pkg.installed:
    - pkgs:
      - libmariadb-dev
      # The above ones are necessary on Debian for the mysqlclient
{% else %}
# Fedora, CentOS, AlmaLinux, Rocky, ...
mysqlclient-build-tools:
  pkg.group_installed:
    - name: 'Development Tools'

mysqlclient-dev-pkg:
  pkg.installed:
    - pkgs:
        - mariadb-devel
{% endif %}

mysqlclient-pip-pkg-installed:
  pip.installed:
    - name: mysqlclient
    - required:
        - pkg: mysqlclient-build-tools
        - pkg: mysqlclient-dev-pkg
{#
   ## I hope that saltext-mysql will be able to function with just the
   ## the default 'python3-mariadb-connector' package instead.
   ## For now we are stuck with this relatively heavy dependency.
mysqlclient-pip-pkg-installed:
  pkg.installed:
    - name: python3-mariadb-connector # Debian
#}

saltext-mysql-pip-pkg-installed:
  pip.installed:
    - name: saltext-mysql
    - required:
        - pkg: mysqlclient-pip-pkg-installed

