=====
mysql
=====

Install the MySQL client and/or server.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``mysql.client``
----------------

Install the MySQL client package.

``mysql.server``
----------------

Install the MySQL server package and start the service.

Debian OS family supports setting MySQL root password during install via debconf.

``mysql.database``
----------------

Create and manage MySQL databases.

``mysql.database``
----------------

Create and manage MySQL database users with definable GRANT privileges.