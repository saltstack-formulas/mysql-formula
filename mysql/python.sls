{% set pkg = salt['grains.filter_by']({
  'Debian': {'name': 'python-mysqldb'},
  'RedHat': {'name': 'MySQL-python'},
}) %}

mysqldb-python:
  pkg:
    - installed
    - name: {{ pkg.name }}
