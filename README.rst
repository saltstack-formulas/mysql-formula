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

``mysql``
---------

Meta-state that includes all server packages in the correct order.

This meta-state does **not** include ``mysql.remove_test_database``; see
below for details.

``mysql.client``
----------------

Install the MySQL client package.

``mysql.server``
----------------

Install the MySQL server package and start the service.

Debian OS family supports setting MySQL root password during install via
debconf.

.. note::

    If no root password is provided in the pillar, a random one will
    be created. Because Hydrogen doesn't have easy access to a random
    function (test.rand_str isn't introduced until Helium), instead,
    we use the not-at-all random ``grains.server_id``. As this is
    cryptographically insecure, future formula versions should use the
    newly available ``random.get_str`` method.

.. note::
    For mariaDB under Debian jessie, use the following pillar values: ``debconf_package:``
    and ``debconf:``

    They are new pillar's variable to feed debconf.

::
  
  # example of pillar
  mysql:
    lookup:
      server: mariadb-server
      client: mariadb-client
      debconf_package: mariadb-server-10.0
      debconf: mysql-server
      service: mysql
      python: python-mysqldb


``mysql.disabled``
------------------

Ensure that the MySQL service is not running.

``mysql.database``
------------------

Create and manage MySQL databases.

``mysql.python``
----------------

Install mysql python bindings.

``mysql.user``
--------------

Create and manage MySQL database users with definable GRANT privileges.

The state accepts MySQL hashed passwords or clear text. Hashed password have
priority.

.. note::
    See the `salt.states.mysql_user
    <http://docs.saltstack.com/en/latest/ref/states/all/salt.states.mysql_user.html#module-salt.states.mysql_user>`_
    docs for additional information on configuring hashed passwords.

    Make sure to **quote the passwords** in the pillar so YAML doesn't throw an exception.

``mysql.remove_test_database``
------------------------------

.. warning::

   Do not use this state if your MySQL instance has a database in use called ``test``.
   If you do, it will be irrevocably removed!

Remove the database called ``test``, normally created as part of a default
MySQL installation.  This state is **not** included as part of the meta-state
above as this name may conflict with a real database.

``mysql.dev``
-------------

Install the MySQL development libraries and header files.

.. note::
    Note that this state is not installed by the mysql meta-state unless you set
    your pillar data accordingly.


