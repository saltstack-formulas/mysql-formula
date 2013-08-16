{% from "mysql/package-map.jinja" import mysql with context %}

mysql:
  pkg:
    - installed
    - name: {{ mysql.client }}
