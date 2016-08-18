{% from "mysql/defaults.yaml" import rawmap with context %}
{%- set mysql = salt['grains.filter_by'](rawmap, grain='os', merge=salt['pillar.get']('mysql:server:lookup')) %}

mysql_php:
  pkg.installed:
    - name: {{ mysql.php }}
