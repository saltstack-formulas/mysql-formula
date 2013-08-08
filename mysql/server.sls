include:
  - mysql

{% set pkg = salt['grains.filter_by']({
  'Debian': {'name': 'mysql-server'},
  'RedHat': {'name': 'mysql-server'},
}) %}

mysqld:
  pkg:
    - installed
    - name: {{ pkg.name }}
  service:
    - running
    - enable: True
  require:
    - pkg: mysql
