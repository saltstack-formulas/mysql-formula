{%- from tpldir ~ "/map.jinja" import mysql with context %}

{%- if "apparmor" in mysql.config %}

mysqld-apparmor-allow:
  file.append:
    - name: {{ mysql.config.apparmor.dir }}/{{ mysql.config.apparmor.file }}
    - onlyif: test -d {{ mysql.config.apparmor.dir }}
    - makedirs: True
    - text:
      - '{{ mysql.config.sections.mysqld.datadir }}/ r,'
      - '{{ mysql.config.sections.mysqld.datadir }}/** rwk,'

{%- endif %}
