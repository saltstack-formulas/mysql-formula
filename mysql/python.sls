{% from tpldir ~ "/map.jinja" import mysql with context %}

mysql_python:
  pkg.installed:
    - name: {{ mysql.pythonpkg }}
