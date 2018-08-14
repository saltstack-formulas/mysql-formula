{% from tpldir ~ "/map.jinja" import mysql with context %}

mysql_dev:
  pkg:
    - installed
    - name: {{ mysql.devpkg }}
