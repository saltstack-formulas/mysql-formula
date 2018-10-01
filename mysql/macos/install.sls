###  mysql/macos/install.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{%- from salt.file.dirname(tpldir) ~ "/map.jinja" import mysql with context -%}

   {%- set dl = mysql.macos.dl %}

mysql-macos-extract-dirs:
  file.directory:
    - name: {{ dl.tmpdir }}
    - makedirs: True
    - clean: True

  {%- for product, data in mysql.macos.products.items() if data.enabled %}
      {%- set archivename = data.url.split('/')[-1]|quote %}
      {%- set archiveformat = archivename.split('.')[-1] %}

mysql-macos-remove-previous-{{ product }}-download-archive:
  file.absent:
    - name: {{ dl.tmpdir }}/{{ archivename }}
    - require_in:
      - mysql-macos-download-{{ product }}-archive

mysql-macos-download-{{ product }}-archive:
  pkg.installed:
    - name: curl
  cmd.run:
    - name: curl {{ dl.opts }} -o {{ dl.tmpdir }}/{{ archivename }} {{ data.url }}
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
     - path: {{ dl.tmpdir }}/{{ archivename }}
     - file_hash: {{ data.sum }}
     - onchanges:
       - mysql-macos-download-{{ product }}-archive
     - require_in:
       - mysql-macos-{{ product }}-install
     {%- endif %}

mysql-macos-{{ product }}-install:
     {%- if archiveformat in ('dmg',) %}
  macpackage.installed:
    - name: "{{ dl.tmpdir }}/{{ archivename }}"
    - dmg: True
    - app: {{ 'True' if "isapp" not in data else data.isapp }}
    - force: True
    - allow_untrusted: True
    - onchanges:
      - mysql-macos-download-{{ product }}-archive
    - require_in:
      - mysql-macos-remove-{{ product }}-archive
  file.append:
    - name: {{ mysql.macos.userhomes }}/{{ mysql.macos.user }}/.bash_profile
    - text: 'export PATH=$PATH:{{ data.dest }}/Contents/Versions/latest/bin'

     {%- elif archiveformat in ('gz', 'zip',) %}
  archive.extracted:
    - source: file://{{ dl.tmpdir }}{{ archivename }}
    - name: {{ dl.bindir }}
    - trim_output: True
    - source_hash: {{ data.sum }}
    - onchanges:
      - mysql-macos-download-{{ product }}-archive
    - require_in:
      - mysql-macos-remove-{{ product }}-archive

     {%- endif %}

mysql-macos-remove-{{ product }}-archive:
  file.absent:
    - name: {{ dl.tmpdir }}/{{ archivename }}
    - onchanges:
      - mysql-macos-download-{{ product }}-archive

  {%- endfor %}

