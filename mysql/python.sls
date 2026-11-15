{%- from tpldir ~ "/map.jinja" import mysql with context %}

{% if grains['os_family'] == 'Debian' %}
mysqlclient-build-tools:
  pkg.installed:
    - pkgs:
      - build-essential
      - pkgconf

mysqlclient-dev-pkg:
  pkg.installed:
    - pkgs:
      - libmariadb-dev
{% elif grains['os_family'] == 'Suse' %}
mysqlclient-build-tools:
  pkg.installed:
    - pkgs:
      - gcc
      - make
      - pkgconf-pkg-config

mysqlclient-dev-pkg:
  pkg.installed:
    - pkgs:
      - libmariadb-devel
{% else %}
# Fedora, CentOS, AlmaLinux, Rocky, Amazon Linux, ...
mysqlclient-build-tools:
  pkg.installed:
    - pkgs:
      - gcc
      - make
      - pkgconf-pkg-config

mysqlclient-dev-pkg:
  pkg.installed:
    - pkgs:
        - mariadb-connector-c-devel
        # In Fedora this became an alias for mariadb-devel.
{% endif %}

mysqlclient-pip-pkg-installed:
  pip.installed:
    - name: mysqlclient
    - reload_modules: true
    - required:
        - pkg: mysqlclient-build-tools
        - pkg: mysqlclient-dev-pkg
{# ## The above replaces the installation of mysql.pythonpkg
   ## which is the PyMySQL/python3-mysqldb package, which is a pure python
   ## MySQL implementation that does not require a C compiler.
   ## Too many distibutions have issues with this. Currently the ony way to 
   ## have the saltext-mysql extension working correctly is with 'mysqlclient'.
# mysql_python:
#   pkg.installed:
#     - name: {{ mysql.pythonpkg }}
#     - reload_modules: true
   ## This is 
#}

saltext-mysql-pip-pkg-installed:
  pip.installed:
    - name: saltext-mysql
    - reload_modules: true
    - required:
        - pkg: mysqlclient-pip-pkg-installed