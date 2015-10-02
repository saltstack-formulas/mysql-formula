include:
  - mysql.config

{% from "mysql/defaults.yaml" import rawmap with context %}
{%- set mysql = salt['grains.filter_by'](rawmap, grain='os', merge=salt['pillar.get']('mysql:lookup')) %}

mysql:
  pkg.installed:
    - name: {{ mysql.client }}
