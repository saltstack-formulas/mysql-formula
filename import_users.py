#!/usr/bin/env python
"This script helps you to get mysql.user pillar from existent mysql server"

import argparse
import re

try:
    import MySQLdb
except ImportError:
    raise Exception("MySQLdb not found. Install MySQL-python package.")

__author__ = "Egor Potiomkin"
__version__ = "1.0"
__email__ = "eg13reg@gmail.com"

parser = argparse.ArgumentParser()
parser.add_argument('host', metavar='IP', help='host where you want to get users')
parser.add_argument('user', metavar='user', help='mysql user that can show grants')
parser.add_argument('-p', '--password', metavar='password', help='user password', required=False, default=None)
args = parser.parse_args()

# PARSE GRANTS
connection_config = {
    "host": args.host,
    "user": args.user,
    "db": "mysql",
    "use_unicode": True,
    "charset": 'utf8'
}

if args.password:  # some mysql environments (developer ones) use no password
    connection_config['passwd'] = args.password

mysqlcon = MySQLdb.connect(
    **connection_config
)
mysqlCur = mysqlcon.cursor(MySQLdb.cursors.DictCursor)

mysqlCur.execute(r'''select user,host from mysql.user;''')
rows = mysqlCur.fetchall()
users = []

for row in rows:
    users.append({'name': row['user'], 'host': row['host']})

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
                    r"""GRANT ([\s,A-Z_]+) ON `?([a-zA-Z0-9_\-*\\]*)`?\.`?([a-zA-Z0-9_\-*\\]*)`? TO .*""",
                    row[0])
                if mgrant is not None:
                    user['grants'].append(
                        {
                            'grant': [x.strip() for x in mgrant.group(1).split(',')],
                            'database': mgrant.group(2).replace('\\', ''),
                            'table': mgrant.group(3).replace('\\', '')
                        }
                    )
                else:
                    print("ERROR: CAN NOT PARSE GRANTS: ", row[0])
            else:
                user['password'] = mpass.group(1)

    except MySQLdb.DatabaseError:
        print(
            "Error while getting grants for '%s'@'%s'" % (user['name'], user['host'])
        )

    """ PRINT EXAMPLE
    mysql:
        user:
            username:
                host: host
                password_hash: '*2792A97371B2D17789364A22A9B35D180166571A'
                databases:
                    - database: testbase
                    table: table1
                    grants: ['select']
    """
    print("mysql:")
    print("  user:")
    for user in users:
        print("    %s:" % user['name'])
        print("      host: '%s'" % user['host'])
        if ('password' in user):
            print("      password_hash: '%s'" % user['password'])
            print("      databases:")
            for grant in user['grants']:
                print("        - database: '%s'" % grant['database'])
                print("          table: '%s'" % grant['table'])
                print("          grants: ['%s']" % "','".join(grant['grant']).lower())
