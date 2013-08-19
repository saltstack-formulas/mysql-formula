{% from "mysql/package-map.jinja" import pkgs, services, configs with context %}

mysqld:
  pkg:
    - installed
    - name: {{ pkgs['mysql-server'] }}
  service:
    - running
    - name: {{ services['mysql'] }}
    - enable: True
    - watch:
      - pkg: mysqld

{% if grains['os'] in ['Ubuntu', 'Debian', 'Gentoo'] %}
my.cnf:
  file.managed:
    - name: {{ configs['mysql'] }}
    - source: salt://mysql/files/{{ grains['os'] }}-my.cnf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
{% endif %}
