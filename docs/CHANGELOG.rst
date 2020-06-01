
Changelog
=========

`0.53.0 <https://github.com/saltstack-formulas/mysql-formula/compare/v0.52.7...v0.53.0>`_ (2020-06-01)
----------------------------------------------------------------------------------------------------------

Continuous Integration
^^^^^^^^^^^^^^^^^^^^^^


* **kitchen+travis:** use latest pre-salted images (\ `7ea518a <https://github.com/saltstack-formulas/mysql-formula/commit/7ea518a3919f1a59bc6ae821bc0df7577629059a>`_\ )
* **travis:** add notifications => zulip [skip ci] (\ `8adfc4b <https://github.com/saltstack-formulas/mysql-formula/commit/8adfc4bb4fbb49548cf46d277a0403b89c180b1a>`_\ )

Features
^^^^^^^^


* **focal:** add settings for ``ubuntu-20.04`` (\ `0d77164 <https://github.com/saltstack-formulas/mysql-formula/commit/0d77164f394909ec371f39cb41a4920c82e75052>`_\ )

`0.52.7 <https://github.com/saltstack-formulas/mysql-formula/compare/v0.52.6...v0.52.7>`_ (2020-05-19)
----------------------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* **osfamilymap.yaml:** update SUSE defaults (\ `8ee79a7 <https://github.com/saltstack-formulas/mysql-formula/commit/8ee79a7bb03488e4c3632a1dcfe143696a11aad5>`_\ )

Continuous Integration
^^^^^^^^^^^^^^^^^^^^^^


* **gemfile.lock:** add to repo with updated ``Gemfile`` [skip ci] (\ `9e9fa3e <https://github.com/saltstack-formulas/mysql-formula/commit/9e9fa3e3d15e25ad22f75eae61af4883c79b7c0f>`_\ )
* **kitchen+travis:** remove ``master-py2-arch-base-latest`` [skip ci] (\ `c1dddc3 <https://github.com/saltstack-formulas/mysql-formula/commit/c1dddc3a8d561847094bbe23fe2c764c8fdf79de>`_\ )
* **workflows/commitlint:** add to repo [skip ci] (\ `b4c6570 <https://github.com/saltstack-formulas/mysql-formula/commit/b4c65702b91e8813741bf72008e41d1d8dfc735d>`_\ )

`0.52.6 <https://github.com/saltstack-formulas/mysql-formula/compare/v0.52.5...v0.52.6>`_ (2020-04-17)
----------------------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* **reload-modules:** do ``reload_modules`` on py module installation (\ `2b6e704 <https://github.com/saltstack-formulas/mysql-formula/commit/2b6e704c96d0373aadb56f90d758c960f538abdb>`_\ )

Continuous Integration
^^^^^^^^^^^^^^^^^^^^^^


* **gemfile:** restrict ``train`` gem version until upstream fix [skip ci] (\ `04f75a7 <https://github.com/saltstack-formulas/mysql-formula/commit/04f75a7a3b43de9425a8f36dc202b7ecf0c4f856>`_\ )
* **kitchen:** avoid using bootstrap for ``master`` instances [skip ci] (\ `ef7a2ce <https://github.com/saltstack-formulas/mysql-formula/commit/ef7a2ce2d857dd271ec0704ab951c8337cb6b64e>`_\ )
* **travis:** use ``major.minor`` for ``semantic-release`` version [skip ci] (\ `b4f5f79 <https://github.com/saltstack-formulas/mysql-formula/commit/b4f5f79781631d7d31061b880df3066ac5bc5860>`_\ )

`0.52.5 <https://github.com/saltstack-formulas/mysql-formula/compare/v0.52.4...v0.52.5>`_ (2019-12-10)
----------------------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* **db_load:** preserve space between -h and -p on the db load ``cmd.wait`` (\ `a05f263 <https://github.com/saltstack-formulas/mysql-formula/commit/a05f263f4b9eac52a5854fd57a6a24f997ccb291>`_\ )

`0.52.4 <https://github.com/saltstack-formulas/mysql-formula/compare/v0.52.3...v0.52.4>`_ (2019-12-03)
----------------------------------------------------------------------------------------------------------

Styles
^^^^^^


* remove previous line from jinja directives (\ `ec0e2a7 <https://github.com/saltstack-formulas/mysql-formula/commit/ec0e2a765a587d0df94b0afb9f7a4ef78a5319ab>`_\ )

`0.52.3 <https://github.com/saltstack-formulas/mysql-formula/compare/v0.52.2...v0.52.3>`_ (2019-12-03)
----------------------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* **mac_shortcut.sh:** fix ``shellcheck`` errors (\ `7b309f8 <https://github.com/saltstack-formulas/mysql-formula/commit/7b309f8da272ebdcb36dbfa7619a0fc9872a79a7>`_\ )
* **release.config.js:** use full commit hash in commit link [skip ci] (\ `3f51b8b <https://github.com/saltstack-formulas/mysql-formula/commit/3f51b8bbc231a7455e6763b415221abff636d8a2>`_\ )

Continuous Integration
^^^^^^^^^^^^^^^^^^^^^^


* **kitchen:** use ``debian-10-master-py3`` instead of ``develop`` [skip ci] (\ `5efe938 <https://github.com/saltstack-formulas/mysql-formula/commit/5efe9387fde63e0c09d99d5771f3b623fb934242>`_\ )
* **kitchen:** use ``develop`` image until ``master`` is ready (\ ``amazonlinux``\ ) [skip ci] (\ `63bfb4a <https://github.com/saltstack-formulas/mysql-formula/commit/63bfb4a0f25b62bdc45c1738d438ce5ec64f2183>`_\ )
* **kitchen+travis:** upgrade matrix after ``2019.2.2`` release [skip ci] (\ `27ac5a3 <https://github.com/saltstack-formulas/mysql-formula/commit/27ac5a3f684325a8e15736bb85d4774807061534>`_\ )
* **travis:** apply changes from build config validation [skip ci] (\ `d520848 <https://github.com/saltstack-formulas/mysql-formula/commit/d520848c815a9c2815ee3f1943e3e3962a26c7cf>`_\ )
* **travis:** opt-in to ``dpl v2`` to complete build config validation [skip ci] (\ `1a8d914 <https://github.com/saltstack-formulas/mysql-formula/commit/1a8d914fbd5e43f78ee2334b9c5ccd51ee65ad57>`_\ )
* **travis:** quote pathspecs used with ``git ls-files`` [skip ci] (\ `3fb5a82 <https://github.com/saltstack-formulas/mysql-formula/commit/3fb5a82de66dda9a05decc5ee7263729ef913533>`_\ )
* **travis:** run ``shellcheck`` during lint job [skip ci] (\ `0931835 <https://github.com/saltstack-formulas/mysql-formula/commit/0931835f1cfc77022a43242bd3ab04cbed2a3a02>`_\ )
* **travis:** update ``salt-lint`` config for ``v0.0.10`` [skip ci] (\ `1512279 <https://github.com/saltstack-formulas/mysql-formula/commit/1512279c2eac26638720461cc7e847d93d2c77d6>`_\ )
* **travis:** use build config validation (beta) [skip ci] (\ `40d4b97 <https://github.com/saltstack-formulas/mysql-formula/commit/40d4b9763f252f5811d31b2b2df156260bde2b6d>`_\ )

Documentation
^^^^^^^^^^^^^


* **contributing:** remove to use org-level file instead [skip ci] (\ `6afcc80 <https://github.com/saltstack-formulas/mysql-formula/commit/6afcc80396dc4ec2044d8611f18a6ed9075c6a52>`_\ )
* **readme:** update link to ``CONTRIBUTING`` [skip ci] (\ `01f25a3 <https://github.com/saltstack-formulas/mysql-formula/commit/01f25a3ebfbf59d1db2bec73bc5fef9d8bcafd7e>`_\ )

Performance Improvements
^^^^^^^^^^^^^^^^^^^^^^^^


* **travis:** improve ``salt-lint`` invocation [skip ci] (\ `1980c63 <https://github.com/saltstack-formulas/mysql-formula/commit/1980c634b9021c7d29be914bd2a63ddf3c31c8ad>`_\ )

`0.52.2 <https://github.com/saltstack-formulas/mysql-formula/compare/v0.52.1...v0.52.2>`_ (2019-10-11)
----------------------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* **rubocop:** add fixes using ``rubocop --safe-auto-correct`` (\ ` <https://github.com/saltstack-formulas/mysql-formula/commit/fca3b04>`_\ )

Continuous Integration
^^^^^^^^^^^^^^^^^^^^^^


* merge travis matrix, add ``salt-lint`` & ``rubocop`` to ``lint`` job (\ ` <https://github.com/saltstack-formulas/mysql-formula/commit/b2b8863>`_\ )
* **travis:** merge ``rubocop`` linter into main ``lint`` job (\ ` <https://github.com/saltstack-formulas/mysql-formula/commit/26dc562>`_\ )

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
