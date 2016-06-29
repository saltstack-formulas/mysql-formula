#!/bin/bash
#
# salt script for changing mysql root pass
# Usage: change_root_pass.sh {{ my_cnf }} {{ new_root_pass }}

my_cnf="$1"
# WARNING: no double quote in the query, as it wont work in shell
escaped_root_pass="$2"
query="
UPDATE user SET password = password('$escaped_root_pass') WHERE user = 'root';
FLUSH PRIVILEGES;
"
if [[ -e "$my_cnf" ]]
then
  # allready that password
  if ! grep -q "\<${escaped_root_pass}$" "$my_cnf" 
  then
    mysql --defaults-file="$my_cnf" -e "$query" mysql
    exit $?
  fi
else
  echo "no file: $my_cnf"
  exit 1
fi
exit 0
