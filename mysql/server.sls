include:
  - mysql

{% set pkg = salt['grains.filter_by']({
  'Debian': {
    'name': 'mysql-server',
    'service': 'mysql',
  },
  'RedHat': {
    'name': 'mysql-server',
    'service': 'mysqld',
  },
}) %}

mysqld:
  pkg:
    - installed
    - name: {{ pkg.name }}
  service:
    - running
    - name: {{ pkg.service }}
    - enable: True
  require:
    - pkg: mysql
