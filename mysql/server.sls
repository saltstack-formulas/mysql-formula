include:
  - mysql

mysqld:
  service:
    - running
    - enable: True
  require:
    - pkg: mysql
