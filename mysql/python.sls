{% from "mysql/map.jinja" import mysql with context %}

mysql-python:
  pkg:
    - installed
    - name: {{ mysql.python }}
