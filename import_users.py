#!/usr/bin/python
# -*- coding: utf-8 -*-

import argparse
import MySQLdb
import re

parser = argparse.ArgumentParser()
parser.add_argument('host', metavar='IP', help='host where you want to get users')
parser.add_argument('user', metavar='user', help='mysql user that can show grants')
parser.add_argument('password', metavar='password', help='user password')
args = parser.parse_args()

# PARSE GRANTS 
mysqlcon = MySQLdb.connect(host=args.host,user=args.user,passwd=args.password,db="mysql",use_unicode=True, charset='utf8')
mysqlCur = mysqlcon.cursor(MySQLdb.cursors.DictCursor)

mysqlCur.execute(r'''select user,host from mysql.user;''')
rows = mysqlCur.fetchall()
users = []

for row in rows:
	users.append({'name': row['user'], 'host': row['host']});

mysqlCur = mysqlcon.cursor()
grants = []
for user in users:
	q = r'''show grants for '%s'@'%s';''' % (user['name'], user['host'])
	try:
		user['grants'] = []
		mysqlCur.execute(q)
		rows = mysqlCur.fetchall()
		for row in rows:
			mpass = re.search(
				r"""GRANT USAGE ON \*\.\* TO .* IDENTIFIED BY PASSWORD '(\*[A-F0-9]*)\'""",
				row[0])
			if mpass is None:
				mgrant = re.search(
					r"""GRANT ([\s,A-Z]+) ON `?([a-zA-Z0-9_\-*\\]*)`?\.`?([a-zA-Z0-9_\-*\\]*)`? TO .*""",
					row[0])
				if mgrant is not None:					
					user['grants'].append({'grant': [x.strip() for x in mgrant.group(1).split(',')], 'database': mgrant.group(2).replace('\\',''), 'table': mgrant.group(3).replace('\\','')})
				else:
					print "ERROR: CAN NOT PARSE GRANTS: ",row[0]
			else:
				user['password'] = mpass.group(1)

	except MySQLdb.DatabaseError:
		print "Error while getting grants for '%s'@'%s'" % (user['name'], user['host'])
#raise SystemExit
# PRINT RESULT
""" PRINT EXAMPLE
mysql:
  user:
    - name: user
      host: host
      password_hash: '*2792A97371B2D17789364A22A9B35D180166571A'
      databases:
        - database: testbase
          table: table1
          grants: ['select']
"""
print "mysql:"
print "  user:"
for user in users:
	print "    - name: %s" % user['name']
	print "      host: '%s'" % user['host']
	if ('password' in user):
		print "      password_hash: '%s'" % user['password']
	print "      databases:"
	for grant in user['grants']:
		print "        - database: '%s'" % grant['database']
		print "          table: '%s'" % grant['table']
		print "          grants: ['%s']" % "','".join(grant['grant']).lower()