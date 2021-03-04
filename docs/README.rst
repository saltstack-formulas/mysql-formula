.. _readme:

mysql
=====

|img_travis| |img_sr|

.. |img_travis| image:: https://travis-ci.com/saltstack-formulas/mysql-formula.svg?branch=master
   :alt: Travis CI Build Status
   :scale: 100%
   :target: https://travis-ci.com/saltstack-formulas/mysql-formula
.. |img_sr| image:: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
   :alt: Semantic Release
   :scale: 100%
   :target: https://github.com/semantic-release/semantic-release

Install the MySQL client and/or server on Linux and MacOS.

.. contents:: **Table of Contents**

General notes
-------------

See the full `SaltStack Formulas installation and usage instructions
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

If you are interested in writing or contributing to formulas, please pay attention to the `Writing Formula Section
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#writing-formulas>`_.

If you want to use this formula, please pay attention to the ``FORMULA`` file and/or ``git tag``,
which contains the currently released version. This formula is versioned according to `Semantic Versioning <http://semver.org/>`_.

See `Formula Versioning Section <https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#versioning>`_ for more details.

Contributing to this repo
-------------------------

**Commit message formatting is significant!!**

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

Available states
----------------

.. contents::
    :local:

``mysql``
^^^^^^^^^

Meta-state including all server packages in correct order. This meta-state does **not** include ``mysql.remove_test_database``.

``mysql.macos``
^^^^^^^^^^^^^^^^

Install "MySQL Community Server", "MySQL Workbench", and other related mysql products on MacOS (and create Desktop shortcuts).

``mysql.macos.remove``
^^^^^^^^^^^^^^^^

Remove "MySQL Community Server", "MySQL Workbench", and any other enabled products from MacOS.

``mysql.client``
^^^^^^^^^^^^^^^^

Install the MySQL client package on Linux.

``mysql.server``
^^^^^^^^^^^^^^^^

Install the MySQL server package and start the service.

Debian OS family supports setting MySQL root password during install via debconf.

.. note::

    If no root password is provided in the pillar, a random one will
    be created. Because Hydrogen doesn't have easy access to a random
    function (test.rand_str isn't introduced until Helium), instead,
    we use the not-at-all random ``grains.server_id``. As this is
    cryptographically insecure, future formula versions should use the
    newly available ``random.get_str`` method.

``mysql.server_checks``
^^^^^^^^^^^^^^^^^^^^^^^

Enforces a root password to be set.


``mysql.disabled``
^^^^^^^^^^^^^^^^^^

Ensure that the MySQL service is not running.

``mysql.database``
^^^^^^^^^^^^^^^^^^

Create and manage MySQL databases.

``mysql.python``
^^^^^^^^^^^^^^^^

Install mysql python bindings.

``mysql.user``
^^^^^^^^^^^^^^

Create and manage MySQL database users with definable GRANT privileges.

The state accepts MySQL hashed passwords or clear text. Hashed password have
priority.

.. note::
    See the `salt.states.mysql_user
    <http://docs.saltstack.com/en/latest/ref/states/all/salt.states.mysql_user.html#module-salt.states.mysql_user>`_
    docs for additional information on configuring hashed passwords.

    Make sure to **quote the passwords** in the pillar so YAML doesn't throw an exception.

``mysql.remove_test_database``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. warning::

   Do not use this state if your MySQL instance has a database in use called ``test``.
   If you do, it will be irrevocably removed!

Remove the database called ``test``, normally created as part of a default
MySQL installation.  This state is **not** included as part of the meta-state
above as this name may conflict with a real database.

``mysql.dev``
^^^^^^^^^^^^^

Install the MySQL development libraries and header files.

.. note::
    Note that this state is not installed by the mysql meta-state unless you set
    your pillar data accordingly.

``mysql.repo``
^^^^^^^^^^^^^^

Add the official MySQL 5.7 repository.

.. note::
    Note that this state currently only supports MySQL 5.7 for RHEL systems.
    Debian and Suse support to be added. Also need to add the option to allow
    selection of MySQL version (5.6 and 5.5 repos are added but disabled) and
    changed enabled repository accordingly.

``mysql.config``
^^^^^^^^^^^^^^^^^^

Manage the MySQL configuration.

.. note::
    There are currently two common ways to configure MySQL, a monolithic configuration file
    or a configuration directory with configuration files per component. By default this
    state will use a configuration directory for CentOS and Fedora, and a monolithic
    configuration file for all other supported OSes.

    Whether the configuration directory is used or not depends on whether `mysql.config_directory`
    is defined in the pillar. If it is present it will pick the configuration from individual
    component keys (`mysql.server`, `mysql.galera`, `mysql.libraries`, etc) with optional global
    configuration from `mysql.global`. The monolithic configuration, however, is defined separately
    in `mysql.config`.


Testing
-------

Linux testing is done with ``kitchen-salt``.

Requirements
^^^^^^^^^^^^

* Ruby
* Docker

.. code-block:: bash

   $ gem install bundler
   $ bundle install
   $ bin/kitchen test [platform]

Where ``[platform]`` is the platform name defined in ``kitchen.yml``,
e.g. ``debian-9-2019-2-py3``.

``bin/kitchen converge``
^^^^^^^^^^^^^^^^^^^^^^^^

Creates the docker instance and runs the ``mysql`` main state, ready for testing.

``bin/kitchen verify``
^^^^^^^^^^^^^^^^^^^^^^

Runs the ``inspec`` tests on the actual instance.

``bin/kitchen destroy``
^^^^^^^^^^^^^^^^^^^^^^^

Removes the docker instance.

``bin/kitchen test``
^^^^^^^^^^^^^^^^^^^^

Runs all of the stages above in one go: i.e. ``destroy`` + ``converge`` + ``verify`` + ``destroy``.

``bin/kitchen login``
^^^^^^^^^^^^^^^^^^^^^

Gives you SSH access to the instance for manual testing.
