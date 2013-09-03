{% from "mysql/map.jinja" import mysql with context %}

mysql:
  pkg:
    - installed
    - name: {{ mysql.client }}
