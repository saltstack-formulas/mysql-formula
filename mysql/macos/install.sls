###  mysql/macos/install.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{%- from salt.file.dirname(tpldir) ~ "/map.jinja" import mysql with context %}

  {%- set dl = mysql.macos.dl %}

mysql-macos-extract-dirs:
  file.directory:
    - name: {{ dl.tmpdir }}
    - makedirs: True
    - clean: True

  {%- for product, data in mysql.macos.products.items() if "enabled" in data and data.enabled %}
      {%- set archivefile = data.url.split('/')[-1] %}
      {%- set archiveformat = archivefile.split('.')[-1] %}
      {%- set archivename = archivefile|replace('.dmg', '')|replace('.tar.gz', '')|replace('.zip', '') %}

mysql-macos-remove-previous-{{ product }}-download-archive:
  file.absent:
    - name: {{ dl.tmpdir }}/{{ archivefile }}
    - require_in:
      - mysql-macos-download-{{ product }}-archive

mysql-macos-download-{{ product }}-archive:
  pkg.installed:
    - name: curl
  cmd.run:
    - name: curl {{ dl.opts }} -o {{ dl.tmpdir }}/{{ archivefile }} {{ data.url }}
      {% if grains['saltversioninfo'] >= [2017, 7, 0] %}
    - retry:
        attempts: {{ dl.retries }}
        interval: {{ dl.interval }}
      {% endif %}
    - require:
      - mysql-macos-extract-dirs

    {%- if data.sum %}
mysql-macos-check-{{ product }}-archive-hash:
   module.run:
     - name: file.check_hash
     - path: {{ dl.tmpdir }}/{{ archivefile }}
     - file_hash: {{ data.sum }}
     - onchanges:
       - mysql-macos-download-{{ product }}-archive
     - require_in:
       - mysql-macos-{{ product }}-install
    {%- endif %}

mysql-macos-{{ product }}-install:
    {%- if archiveformat in ("dmg",) %}

  macpackage.installed:
    - name: "{{ dl.tmpdir }}/{{ archivefile }}"
    - dmg: True
    - app: {{ 'True' if "isapp" not in data else data.isapp }}
    - force: True
    - allow_untrusted: True
    - onchanges:
      - mysql-macos-download-{{ product }}-archive

    {%- elif archiveformat in ("gz", "zip",) %}

  archive.extracted:
    - source: file://{{ dl.tmpdir }}{{ archivefile }}
    - name: {{ dl.prefix }}/{{ archivename }}
    - trim_output: True
    - source_hash: {{ data.sum }}
    - onchanges:
      - mysql-macos-download-{{ product }}-archive

    {%- endif %}
    - require_in:
      - mysql-macos-tidyup-{{ product }}

      {%- if "path" in data and data.path and "app" in data and data.app %}

mysql-macos-append-{{ product }}-path-to-bash-profile:
  file.append:
    - name: {{ mysql.macos.userhomes }}/{{ mysql.macos.user }}/.bash_profile
    - text: 'export PATH=$PATH:{{ data.path }}/bin'
    - onlyif: test -d {{ data.path }}/bin

mysql-macos-{{ product }}-desktop-shortcut-add:
  file.managed:
    - name: /tmp/mac_shortcut.sh
    - source: salt://mysql/files/mac_shortcut.sh
    - mode: 755
    - template: jinja
    - context:
      user: {{ mysql.macos.user }}
      home: {{ mysql.macos.userhomes }}
      dir: {{'/Applications/' ~ data.app ~ '.app' if "isapp" in data and data.isapp else dl.prefix ~ '/' ~ archivename ~ '/bin'}}
      app: {{ data.app }}
  cmd.run:
    - name: /tmp/mac_shortcut.sh add
    - runas: {{ mysql.macos.user }}
    - require:
      - file: mysql-macos-{{ product }}-desktop-shortcut-add

    {%- endif %}

mysql-macos-tidyup-{{ product }}:
  file.absent:
    - name: {{ dl.tmpdir }}/{{ archivefile }}
    - onchanges:
      - mysql-macos-download-{{ product }}-archive

  {% endfor %}

