{% from "mysql/package-map.jinja" import mysql with context %}

mysqldb-python:
  pkg:
    - installed
    - name: {{ mysql.python }}
