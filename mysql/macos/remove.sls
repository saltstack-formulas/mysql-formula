###  mysql/macos/remove.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{%- from salt.file.dirname(tpldir) ~ "/map.jinja" import mysql with context -%}

  {%- for product, data in mysql.macos.products.items() if data.enabled %}
      {%- set archivename = data.url.split('/')[-1] %}

mysql-macos-{{ product }}-remove-destdir:
  file.absent:
    - names:
      - {{ data.dest }}

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

