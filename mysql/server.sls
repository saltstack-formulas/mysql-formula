{% from "mysql/map.jinja" import mysql with context %}

mysqld:
  pkg:
    - installed
    - name: {{ mysql.server }}
  service:
    - running
    - name: {{ mysql.service }}
    - enable: True
    - watch:
      - pkg: mysqld

{% if grains['os'] in ['Ubuntu', 'Debian', 'Gentoo'] %}
my.cnf:
  file.managed:
    - name: {{ mysql.config }}
    - source: salt://mysql/files/{{ grains['os'] }}-my.cnf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - watch_in:
      - service: mysqld
{% endif %}
