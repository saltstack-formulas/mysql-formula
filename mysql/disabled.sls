{% from tpldir ~ "/map.jinja" import mysql with context %}

mysql:
  service.dead:
      - name: {{ mysql.service }}
      - enable: False
