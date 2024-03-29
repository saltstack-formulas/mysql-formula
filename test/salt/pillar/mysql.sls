# -*- coding: utf-8 -*-
# vim: ft=yaml
---
mysql:
  global:
    client-server:
      default_character_set: utf8

  clients:
    mysql:
      default_character_set: utf8
    mysqldump:
      default_character_set: utf8

  library:
    client:
      default_character_set: utf8

  server:
    # Use this account for database admin (defaults to root)
    # root_user: 'admin'
    # root_password: '' - to have root@localhost without password
    root_password: 'somepass'
    root_password_hash: '*13883BDDBE566ECECC0501CDE9B293303116521A'
    user: mysql
    # If you only manage the dbs and users and the server is on
    # another host
    # host: 123.123.123.123
    # my.cnf sections changes
    mysqld:
      # you can use either underscore or hyphen in param names
      bind-address: 0.0.0.0
      # log_bin: /var/log/mysql/mysql-bin.log
      datadir: /var/lib/mysql
      # port: 3307
      # plugin-load-add: auth_socket.so
      binlog_do_db: foo
      auto_increment_increment: 5
      binlog-ignore-db:
        - mysql
        - sys
        - information_schema
        - performance_schema
    mysql:
      # my.cnf param that not require value
      no-auto-rehash: noarg_present

  # salt_user:
  #   salt_user_name: 'salt'
  #   salt_user_password: 'someotherpass'
  #   grants:
  #     - 'all privileges'

  # Manage config
  config:
    file: ~/.my.cnf
    sections:
      client:
        port: 33306
        socket: /var/lib/mysql-socket/mysql.sock
      mysqld_safe:
        plugin-dir: '~/mysql/plugins'
      mysqld:
        user: myself
        port: 33306
        datadir: ~/mysql/datadir
    apparmor:
      dir: /etc/apparmor.d/local
      file: usr.sbin.mysqld

  # Manage databases
  database:
    # Simple definition using default charset and collate
    - foo
    # Detailed definition
    - name: bar
      character_set: utf8
      collate: utf8_general_ci
    # Delete DB
    - name: obsolete_db
      present: false
  schema:
    foo:
      load: false
    bar:
      load: false
    baz:
      load: true
      source: salt://{{ tpldir }}/files/baz.schema.tmpl
      template: jinja
    qux:
      load: true
      source: salt://{{ tpldir }}/files/qux.schema.tmpl
      template: jinja
      context:
        encabulator: Turbo
        girdlespring: differential
    quux:
      load: true
      source: salt://{{ tpldir }}/files/qux.schema.tmpl
      template: jinja
      context:
        encabulator: Retro
        girdlespring: integral

  # Manage users
  # you can get pillar for existing server using scripts/import_users.py script
  user:
    frank:
      password: 'somepass'
      host: localhost
      databases:
        - database: foo
          grants: ['select', 'insert', 'update']
          escape: true
    # bob:
    #   password_hash: '*6C8989366EAF75BB670AD8EA7A7FC1176A95CEF4'
    #   host: '%' # Any host
    #   ssl: true
    #   ssl-X509: true
    #   ssl-SUBJECT: Subject
    #   ssl-ISSUER: Name
    #   ssl-CIPHER: Cipher
    #   databases:
    #     # https://github.com/saltstack/salt/issues/41178
    #     # If you want to refer to databases using wildcards, turn off escape so
    #     # the renderer does not escape them, enclose the string in '`' and
    #     # use two '%'
    #     - database: '`foo\_%%`'
    #       grants: ['all privileges']
    #       grant_option: true
    #       escape: false
    #     - database: bar
    #       table: foobar
    #       grants: ['select', 'insert', 'update', 'delete']
    nopassuser:
      password: ~
      # host: localhost  # requires unix_socket plugin
      databases: []
    application:
      password: 'somepass'
      mine_hosts:
        target: "G@role:database and *.example.com"
        function: "network.get_hostname"
        expr_form: compound
      databases:
        - database: foo
          grants: ['select', 'insert', 'update']

    # Remove a user
    obsoleteuser:
      host: localhost
      # defaults to true
      present: false

  # Override any names defined in map.jinja
  # serverpkg: mysql-server
  # clientpkg: mysql-client
  # service: mysql
  # pythonpkg: python-mysqldb
  # devpkg: mysql-devel
  # debconf_utils: debconf-utils

  # Install MySQL headers
  dev:
    # Install dev package - defaults to false
    install: false

  macos:
    products:
      community_server:
        enabled: true    # default
        # yamllint disable-line rule:line-length
        url: https://downloads.mysql.com/archives/get/file/mysql-8.0.11-macos10.13-x86_64.dmg
        sum: 'md5=602a84390ecf3d82025b1d99fc594124'
      workbench:
        enabled: true    # default
        # yamllint disable-line rule:line-length
        url: https://downloads.mysql.com/archives/get/file/mysql-workbench-community-8.0.11-rc-macos-x86_64.dmg
        sum: 'md5=37c5ae5bd75a4e1804ae6e0127d68611'
      cluster:
        enabled: false  # default
        # yamllint disable-line rule:line-length
        url: https://downloads.mysql.com/archives/get/file/mysql-cluster-gpl-7.6.6-macos10.13-x86_64.dmg
        sum: 'md5=0df975908e7d8e4e8c1003d95edf4721'
      router:
        enabled: false  # default
        # yamllint disable-line rule:line-length
        url: https://downloads.mysql.com/archives/get/file/mysql-router-8.0.11-macos10.13-x86-64bit.dmg
        sum: 'md5=8dd536f2f223933ecbfb8b19e54ee2f6'
      utilities:
        enabled: false  # default
        # yamllint disable-line rule:line-length
        url: https://downloads.mysql.com/archives/get/file/mysql-utilities-1.6.5-macos10.12.dmg
        sum: 'md5=4c8e75bb217b8293dcdeb915b649c2c8'
      shell:
        enabled: false  # default
        # yamllint disable-line rule:line-length
        url: https://downloads.mysql.com/archives/get/file/mysql-shell-8.0.11-macos10.13-x86-64bit.dmg
        sum: 'md5=43db4f0fc39f88c1d7be4a4f52cec363'
      proxy:
        enabled: false  # default
        # yamllint disable-line rule:line-length
        url: https://downloads.mysql.com/archives/get/file/mysql-proxy-0.8.5-osx10.7-x86-32bit.tar.gz
        sum: 'md5=107df22412aa8c483d2021e1af24ee22'
      connector:
        enabled: false  # default
        # yamllint disable-line rule:line-length
        url: https://downloads.mysql.com/archives/get/file/mysql-connector-nodejs-8.0.11.tar.gz
        sum: 'md5=dece7fe5607918ba68499ef07c31508d'
      forvisualstudio:
        enabled: false  # default
        # yamllint disable-line rule:line-length
        url: https://downloads.mysql.com/archives/get/file/mysql-for-visualstudio-2.0.4-src.zip
        sum: 'md5=fcf39316505ee2921e31a431eae77a9c'
      forexcel:
        enabled: false  # default
        # yamllint disable-line rule:line-length
        url: https://downloads.mysql.com/archives/get/file/mysql-for-excel-1.3.6-src.zip
        sum: 'md5=2cc8b65eb72a1b07a6e4e2665e2a29e3'
      notifier:
        enabled: false  # default
        # yamllint disable-line rule:line-length
        url: https://downloads.mysql.com/archives/get/file/mysql-notifier-1.1.6-src.zip
        sum: 'md5=349f1994681763fd6626a8ddf6be5363'
