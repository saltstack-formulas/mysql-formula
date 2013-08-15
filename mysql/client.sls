{% from "salt/package-map.jinja" import pkgs, services with context %}

mysql:
  pkg:
    - installed
    - name: {{ pkgs['mysql-client'] }}
