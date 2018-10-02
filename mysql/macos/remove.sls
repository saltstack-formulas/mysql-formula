###  mysql/macos/remove.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{%- from salt.file.dirname(tpldir) ~ "/map.jinja" import mysql with context -%}

  {%- set dl = mysql.macos.dl %}
  {%- for product, data in mysql.macos.products.items() if "app" in data and data.app and "url" in data and data.url  %}
      {%- set archivename = data.url.split('/')[-1]|replace('.dmg', '')|replace('.tar.gz', '')|replace('.zip', '') %}

mysql-macos-{{ product }}-remove-destdir:
  file.absent:
    - names:
      - {{ '/Applications' ~ data.app ~ '.app' if "isapp" in data and data.isapp else dl.prefix ~ '/' ~ archivename  }}

mysql-macos-{{ product }}-desktop-shortcut-remove:
  file.managed:
    - name: /tmp/mac_shortcut.sh
    - source: salt://mysql/files/mac_shortcut.sh
    - mode: 755
    - template: jinja
    - context:
      user: {{ mysql.macos.user }}
      home: {{ mysql.macos.userhomes }}
      app: {{ data.app }}
      dir: {{ '/Applications' if "isapp" in data and data.isapp else dl.prefix ~ '/' ~ archivename ~ '/bin' }}
      suffix: {{ '.app' if "isapp" in data and data.isapp else '' }}
  cmd.run:
    - name: /tmp/mac_shortcut.sh remove
    - runas: {{ mysql.macos.user }}
    - require:
      - file: mysql-macos-{{ product }}-desktop-shortcut-remove

  {%- endfor %}

##https://apple.stackexchange.com/questions/230333/how-could-i-remove-mysql-from-manually-installation-version
##https://community.jaspersoft.com/wiki/uninstall-mysql-mac-os-x
mysql-macos-remove-entry-in-/etc/hostconfig:
  file.line:
    - name: /etc/hostconfig
    - mode: delete
    - content: MYSQLCOM=-YES-
    - onlyif: test -f /etc/hostconfig

mysql-macos-remove-mysql-fully:
  file.absent:
    - names:
      - {{ mysql.macos.dl.tmpdir }}
      - /usr/local/mysql*
      - /Library/PreferencePanes/MySQL.prefPane
      - /Library/StartupItems/MySQLCOM
      - /Library/Receipts/mysql*
      - /Library/Receipts/MySQL*
      - /private/var/db/receipts/*mysql*
      - /Library/LaunchDaemons/com.oracle.oss.mysql.*

