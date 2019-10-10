
Changelog
=========

`0.52.1 <https://github.com/saltstack-formulas/mysql-formula/compare/v0.52.0...v0.52.1>`_ (2019-10-10)
----------------------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* **server.sls:** fix ``salt-lint`` errors (\ ` <https://github.com/saltstack-formulas/mysql-formula/commit/764dd0c>`_\ )
* **user.sls:** fix ``salt-lint`` errors (\ ` <https://github.com/saltstack-formulas/mysql-formula/commit/a014e55>`_\ )

Continuous Integration
^^^^^^^^^^^^^^^^^^^^^^


* **kitchen:** change ``log_level`` to ``debug`` instead of ``info`` (\ ` <https://github.com/saltstack-formulas/mysql-formula/commit/75fd8dc>`_\ )
* **kitchen:** install required packages to bootstrapped ``opensuse`` [skip ci] (\ ` <https://github.com/saltstack-formulas/mysql-formula/commit/8b89ebc>`_\ )
* **kitchen:** use bootstrapped ``opensuse`` images until ``2019.2.2`` [skip ci] (\ ` <https://github.com/saltstack-formulas/mysql-formula/commit/4bdaab7>`_\ )
* **platform:** add ``arch-base-latest`` (commented out for now) [skip ci] (\ ` <https://github.com/saltstack-formulas/mysql-formula/commit/5c20c9b>`_\ )
* **yamllint:** add rule ``empty-values`` & use new ``yaml-files`` setting (\ ` <https://github.com/saltstack-formulas/mysql-formula/commit/2322ff6>`_\ )
* merge travis matrix, add ``salt-lint`` & ``rubocop`` to ``lint`` job (\ ` <https://github.com/saltstack-formulas/mysql-formula/commit/00494d5>`_\ )
* use ``dist: bionic`` & apply ``opensuse-leap-15`` SCP error workaround (\ ` <https://github.com/saltstack-formulas/mysql-formula/commit/05b1cef>`_\ )

`0.52.0 <https://github.com/saltstack-formulas/mysql-formula/compare/v0.51.0...v0.52.0>`_ (2019-08-17)
----------------------------------------------------------------------------------------------------------

Features
^^^^^^^^


* **yamllint:** include for this repo and apply rules throughout (\ `9f739fa <https://github.com/saltstack-formulas/mysql-formula/commit/9f739fa>`_\ )

`0.51.0 <https://github.com/saltstack-formulas/mysql-formula/compare/v0.50.0...v0.51.0>`_ (2019-08-08)
----------------------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* **connector:** fix typos (connnector) and missing ``enabled`` (\ `bdee94a <https://github.com/saltstack-formulas/mysql-formula/commit/bdee94a>`_\ )

Features
^^^^^^^^


* **linux:** archlinux support (no osmajorrelase grain) (\ `4b4ad88 <https://github.com/saltstack-formulas/mysql-formula/commit/4b4ad88>`_\ )

`0.50.0 <https://github.com/saltstack-formulas/mysql-formula/compare/v0.49.0...v0.50.0>`_ (2019-07-12)
----------------------------------------------------------------------------------------------------------

Features
^^^^^^^^


* **semantic-release:** implement for this formula (\ `1d2e2f5 <https://github.com/saltstack-formulas/mysql-formula/commit/1d2e2f5>`_\ )
