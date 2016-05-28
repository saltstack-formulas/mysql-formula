#!/bin/bash
#
# lazy exec wrapper from saltmaster.
#
# Usage:
#   ./master_exec.sh 'minion' remove_mariadb.sh
#   ./master_exec.sh 'minion' remove_all_users.sql
#   ./master_exec.sh 'minion' SOME_SCRIPT
#
# Note: no space, nor shell reserved char in script names.
# Of course: it could be written as a salf state!
#
# How it works: add a comment, remote_exec:  if the action needs 
#               a specific remote exec call, See remove_all_users.sql
#               for an example.

# check params
minion="$1"
if [[ -z "$minion" || $# -lt 2 ]]
then
  echo missing arugment
  exit 1
fi

# remote copy the file on the minion(s)
salt-cp "$minion" $2 /root

# determine the remote_exec command
remote_exec=$(sed -n -e '/^[#-]\+ remote_exec:/ { s///; s/^ *//; p; }' $2)
if [[ -z "$remote_exec" ]]
then
  # defaut, exec the script.
  remote_exec="chmod a+x $2 && ./$2"
fi

# run!
echo "remote_exec=$remote_exec"
salt "$minion" cmd.run "$remote_exec"
