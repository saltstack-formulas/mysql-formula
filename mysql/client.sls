include:
  - .config

{% from tpldir ~ "/map.jinja" import mysql with context %}

mysql:
  pkg.installed:
    - name: {{ mysql.clientpkg }}
