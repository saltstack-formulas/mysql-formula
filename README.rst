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

``mysql.database``
------------------

Create and manage MySQL databases.

``mysql.python``
------------------

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

Updating the supported parameters
=================================

The ``supported_params.yaml`` file contains the full listing of options that
are acceptable in the MySQL options file.  On occassion, especially on new
releases of MySQL, this file may need to be updated.  To update, run the
supplied script (requires Python 3.x)::

    ./scripts/parse_supported_params.py -o ./mysql/supported_params.yaml

This script will scrape the options from the official MySQL documentation
online, and thus requires web access.  Scraping is inherently brittle, though
this script has been defensively coded, where possible.

Once the ``supported_params.yaml`` file has been updated, commit the result to
the repository.

Support for new applications
----------------------------

To add support for configuration of other MySQL applications, add the URL and
section identifier into the relevant section of the script.  Consult the
comments in the code to determine where your section should be added.
