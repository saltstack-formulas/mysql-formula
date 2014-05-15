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
------------------

Create and manage MySQL databases.

``mysql.user``
----------------

Create and manage MySQL database users with definable GRANT privileges.

The state accepts MySQL hashed passwords or clear text. Hashed password have priority.

.. note::
    See the `salt.states.mysql_user <http://docs.saltstack.com/en/latest/ref/states/all/salt.states.mysql_user.html#module-salt.states.mysql_user>`_ docs for additional information on configuring hashed passwords.
    
    Make sure to **quote the passwords** in the pillar so YAML doesn't throw an exception.

