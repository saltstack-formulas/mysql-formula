{% set pkg = salt['grains.filter_by']({
  'Debian': {'name': 'mysql-client'},
  'RedHat': {'name': 'mysql'},
}) %}

mysql:
  pkg:
    - installed
    - name: {{ pkg.name }}
