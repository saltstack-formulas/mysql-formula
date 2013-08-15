{% from "salt/package-map.jinja" import pkgs with context %}

mysql:
  pkg:
    - installed
    - name: {{ pkgs['mysql-client'] }}
