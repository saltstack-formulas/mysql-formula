#!/usr/bin/python3
# coding: utf-8
import argparse
import re
import sys
import urllib.request
from html_table_parser import HTMLTableParser

# Regex for parsing options on MySQL documentation pages
# Options are (normally) specified as command-line options
# as anchor tags on the page.  Certain documentation pages only
# show options in table listings, however.
OPTION_REGEX = '<a name="option_%s_(.*?)"></a>'
OPTION_TABLE_REGEX = '^(--)?([A-Za-z_-]+).*$'

# File heading, as per the original supported_params file
FILE_HEADER = """# vim
{#- Do not edit this YAML file by hand. See README.rst for how to update -#}
{% load_yaml as supported_params %}
"""
FILE_FOOTER = """{% endload %}"""

# Standard YAML template for options for a section
YAML_TEMPLATE = """# From %(url)s
%(section)s:
  - %(options)s
"""

# For rendering Jinja that handles multiple sections
# Several MySQL utilities use exactly the same options
# Note this variable is string formatted twice, hence the double-double % signs
YAML_TEMPLATE_MULTI = """# From %%(url)s
{%%%% for section in %(sections)r %%%%}
{{ section  }}:
  - %%(options)s
{%%%% endfor %%%%}
"""

# Options specified in HTML documentation as command-line options
# like so <a name="option_mysql_help"></a>.
# Structure is (section_id, documentation_url, yaml_template_str)
SECTIONS = (
    ('mysql',
     'https://dev.mysql.com/doc/refman/5.7/en/mysql-command-options.html',
     YAML_TEMPLATE_MULTI % {'sections': ['client', 'mysql']}),
    ('mysqldump',
     'https://dev.mysql.com/doc/refman/5.7/en/mysqldump.html',
     YAML_TEMPLATE),
    ('mysqld_safe',
     'https://dev.mysql.com/doc/refman/5.7/en/mysqld-safe.html',
     YAML_TEMPLATE),
    # Removed in MySQL 5.7
    ('mysqlhotcopy',
     'http://dev.mysql.com/doc/refman/5.6/en/mysqlhotcopy.html',
     YAML_TEMPLATE),
    ('mysqladmin',
     'http://dev.mysql.com/doc/refman/5.7/en/mysqladmin.html',
     YAML_TEMPLATE),
    ('mysqlcheck',
     'http://dev.mysql.com/doc/refman/5.7/en/mysqlcheck.html',
     YAML_TEMPLATE),
    ('mysqlimport',
     'http://dev.mysql.com/doc/refman/5.7/en/mysqlimport.html',
     YAML_TEMPLATE),
    ('mysqlshow',
     'http://dev.mysql.com/doc/refman/5.7/en/mysqlshow.html',
     YAML_TEMPLATE),
    ('myisampack',
     'http://dev.mysql.com/doc/refman/5.7/en/myisampack.html',
     YAML_TEMPLATE),
)
# Options specified in documentation as command-line and
# option file values in a table only.
SECTIONS_VIA_TABLE = (
    ('myisamchk',
     'https://dev.mysql.com/doc/refman/5.7/en/myisamchk.html',
     YAML_TEMPLATE_MULTI % {'sections': ['myisamchk', 'isamchk']}),
)
# Server options specified in documentation
SERVER_OPTIONS = (
    'mysqld',
    'https://dev.mysql.com/doc/refman/5.7/en/mysqld-option-tables.html',
    YAML_TEMPLATE
)


def read_url(url):
    """ Read the given URL and decode the response as UTF-8.
    """
    request = urllib.request.Request(url)
    response = urllib.request.urlopen(request)
    return response.read().decode('utf-8')


def read_first_table(url):
    """ Read the given URL, parse the result, and return the first table.
    """
    xhtml = read_url(url)
    parser = HTMLTableParser()
    parser.feed(xhtml)
    return parser.tables[0]  # Use first table on the page


def parse_anchors(url, section):
    """ Return parsed options from option anchors at the given URL.
    """
    return re.findall(OPTION_REGEX % section, read_url(url))


def parse_tables(url, section):
    """ Return arsed options from HTML tables at the given URL.

    This matches the given option regex, and ensures that the
    first row of the table is ignored; it contains headings only.
    """
    table = read_first_table(url)
    return [re.match(OPTION_TABLE_REGEX, row[0]).groups()[1]
            for row in table[1:]]


def parse_mysqld(url, section):
    """ Return the parsed options from the huge mysqld table.

    The massive options table shows variables and options and
    highlights where they can be used.  The following code only
    pulls out those that are marked as 'Yes' for use in an option file.
    """
    table = read_first_table(url)
    # Find which column holds the option file data
    option_index = table[0].index('Option File')
    # Only pull out options able to be used in an options file
    return [re.match(OPTION_TABLE_REGEX, row[0]).groups()[1]
            for row in table[1:]
            if len(row) >= option_index + 1 and
            row[option_index].strip().lower() == 'yes']


def print_yaml_options(sections, parser, file=sys.stdout):
    """ Perform really basic templating for output.

    A YAML library could be used, but we avoid extra dependencies by
    just using string formatting.
    """
    for section, url, yaml in sections:
        options = parser(url, section)
        print(yaml % {'section': section,
                      'options': '\n  - '.join(options),
                      'url': url}, end='', file=file)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Scrape the MySQL documentation to obtain'
                    ' all the supported parameters for different utilities.')
    parser.add_argument('--output',
                        '-o',
                        help='File output location',
                        default=sys.stdout)
    config = parser.parse_args()
    output = open(config.output, 'w') if isinstance(config.output, str) \
        else config.output

    print(FILE_HEADER, end='', file=output)
    print_yaml_options(SECTIONS, parse_anchors, file=output)
    print_yaml_options(SECTIONS_VIA_TABLE, parse_tables, file=output)
    print_yaml_options((SERVER_OPTIONS,), parse_mysqld, file=output)
    print(FILE_FOOTER, end='', file=output)
