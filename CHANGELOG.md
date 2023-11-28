# Changelog

## [0.56.4](https://github.com/saltstack-formulas/mysql-formula/compare/v0.56.3...v0.56.4) (2023-11-28)


### Bug Fixes

* **bug:** config arrays as multiple lines ([fabd837](https://github.com/saltstack-formulas/mysql-formula/commit/fabd837bcbec14e535aca57ef3c2bd132038ff36))


### Continuous Integration

* update `pre-commit` configuration inc. for pre-commit.ci [skip ci] ([3880cd3](https://github.com/saltstack-formulas/mysql-formula/commit/3880cd3a2bd8ac6d2482b0e9a2365db2db9aff2a))
* **kitchen+gitlab:** update for new pre-salted images [skip ci] ([47ff13c](https://github.com/saltstack-formulas/mysql-formula/commit/47ff13c31413e1f1236435c92136e34054e5adc3))


### Styles

* update precommit and style ([5f487e3](https://github.com/saltstack-formulas/mysql-formula/commit/5f487e33f688d4c12ba6f5c902d89ac535249373))


### Tests

* **packages:** update for `ubuntu-22.04` [skip ci] ([6e2433e](https://github.com/saltstack-formulas/mysql-formula/commit/6e2433e29df15aef7514bb4c958211dc4594c831))
* **system:** add `build_platform_codename` [skip ci] ([bb6b4e5](https://github.com/saltstack-formulas/mysql-formula/commit/bb6b4e5a8245aed23ccbc9036702a096b32bf058))
* **system.rb:** add support for `mac_os_x` [skip ci] ([924cc3a](https://github.com/saltstack-formulas/mysql-formula/commit/924cc3a59232d376778f7593c4af78c31c8234a4))

## [0.56.3](https://github.com/saltstack-formulas/mysql-formula/compare/v0.56.2...v0.56.3) (2022-02-12)


### Code Refactoring

* **salt-lint:** fix violation ([7b62a62](https://github.com/saltstack-formulas/mysql-formula/commit/7b62a627e074bef9df4d06d9757ce6217af39d7a))


### Continuous Integration

* update linters to latest versions [skip ci] ([d9a2eb5](https://github.com/saltstack-formulas/mysql-formula/commit/d9a2eb505b919e89f5f08f29db1edcded6d421c4))
* **gemfile:** allow rubygems proxy to be provided as an env var [skip ci] ([0a08d4f](https://github.com/saltstack-formulas/mysql-formula/commit/0a08d4fa9acb3c00dfc9ee78641f66b45fec96fd))
* **kitchen+ci:** update with `3004` pre-salted images/boxes [skip ci] ([3abbd24](https://github.com/saltstack-formulas/mysql-formula/commit/3abbd242a54fb2c600daa04276a05dd31baceee1))
* **kitchen+ci:** update with latest CVE pre-salted images [skip ci] ([c66269a](https://github.com/saltstack-formulas/mysql-formula/commit/c66269abfc4bfdf7fc12c2a110e215b1804caee8))
* **kitchen+gitlab:** update for new pre-salted images [skip ci] ([8ef45fb](https://github.com/saltstack-formulas/mysql-formula/commit/8ef45fbe7124b3ca60505bbd383ce762a89a6406))

## [0.56.2](https://github.com/saltstack-formulas/mysql-formula/compare/v0.56.1...v0.56.2) (2021-09-04)


### Bug Fixes

* **centos7:** add correct pymysql package on cent7/saltpy3 ([9722b02](https://github.com/saltstack-formulas/mysql-formula/commit/9722b0218763c56b7bb1096b421058e6898ae55e))
* **ci:** corrected ruby last else ([df2fa30](https://github.com/saltstack-formulas/mysql-formula/commit/df2fa300eff9c07e54967a3ef1366c57896b4eb5))


### Continuous Integration

* **centos:** add centos ci; fix test pillar ([060b43f](https://github.com/saltstack-formulas/mysql-formula/commit/060b43f3036bbdfd1c0910fe91ff280221ef116c))

## [0.56.1](https://github.com/saltstack-formulas/mysql-formula/compare/v0.56.0...v0.56.1) (2021-08-25)


### Code Refactoring

* **jinja:** improve indentation ([d09728e](https://github.com/saltstack-formulas/mysql-formula/commit/d09728e04f0405e0e085b68210210ced9d892fe4))


### Continuous Integration

* **gemfile+lock:** use `ssf` customised `inspec` repo [skip ci] ([8f91b4f](https://github.com/saltstack-formulas/mysql-formula/commit/8f91b4f3ecd2b9c9ee862aa607993f5b81ef4d6c))
* **kitchen+ci:** update with latest `3003.2` pre-salted images [skip ci] ([d908ad5](https://github.com/saltstack-formulas/mysql-formula/commit/d908ad5e5558e236812860095222cdfb5f80ff08))

# [0.56.0](https://github.com/saltstack-formulas/mysql-formula/compare/v0.55.2...v0.56.0) (2021-07-19)


### Continuous Integration

* add Debian 11 Bullseye & update `yamllint` configuration [skip ci] ([ee34e48](https://github.com/saltstack-formulas/mysql-formula/commit/ee34e48fae56a5ca06557d8997e47d100eef8c48))
* **3003.1:** update inc. AlmaLinux, Rocky & `rst-lint` [skip ci] ([4d5e6d9](https://github.com/saltstack-formulas/mysql-formula/commit/4d5e6d9e1924fdabae726b1ef6cdc58b8dcb331f))
* **kitchen:** move `provisioner` block & update `run_command` [skip ci] ([f51d4ba](https://github.com/saltstack-formulas/mysql-formula/commit/f51d4ba4ced7d7a6b13da091b838e60a16be7d1b))
* **kitchen+gitlab:** remove Ubuntu 16.04 & Fedora 32 (EOL) [skip ci] ([13c8450](https://github.com/saltstack-formulas/mysql-formula/commit/13c8450069aad9bf1ff25a0c7870a82d5a0b3e7f))
* add `arch-master` to matrix and update `.travis.yml` [skip ci] ([8dbff38](https://github.com/saltstack-formulas/mysql-formula/commit/8dbff388203b9b6156d07e6cc4bb6558c7ad72e0))


### Features

* **freebsd:** update packages from ``py37-*`` => ``py38-*`` ([70eeed8](https://github.com/saltstack-formulas/mysql-formula/commit/70eeed80c1b0ce0dfd1ffe539b5e0be6ba5415fd))
* **osfingermap:** add support for `Debian 11` [skip ci] ([3ea9b34](https://github.com/saltstack-formulas/mysql-formula/commit/3ea9b347590e6f15761d07567a7640d138f74128))

## [0.55.2](https://github.com/saltstack-formulas/mysql-formula/compare/v0.55.1...v0.55.2) (2021-05-07)


### Bug Fixes

* **salt-user:** fix setting grants for the salt user ([346633d](https://github.com/saltstack-formulas/mysql-formula/commit/346633d6f65a4da5e44a9e7c1cff9f00e0e2075b))


### Continuous Integration

* **kitchen+gitlab:** adjust matrix to add `3003` [skip ci] ([3df6d64](https://github.com/saltstack-formulas/mysql-formula/commit/3df6d6410d0ad74d51cb26032d4917617913d835))


### Documentation

* **readme:** fix headings [skip ci] ([897a83d](https://github.com/saltstack-formulas/mysql-formula/commit/897a83dc2ae0430144f5c1ef0dde29f05839fe69))


### Tests

* standardise use of `share` suite & `_mapdata` state [skip ci] ([c11750c](https://github.com/saltstack-formulas/mysql-formula/commit/c11750c9ccb702cfa28bbae4b3e2481e835729c1))

## [0.55.1](https://github.com/saltstack-formulas/mysql-formula/compare/v0.55.0...v0.55.1) (2021-03-23)


### Bug Fixes

* **salt-user:** redirect error output from user access checks ([4cb4c05](https://github.com/saltstack-formulas/mysql-formula/commit/4cb4c05e48272c8073b0798afa8b31f232d12674))


### Continuous Integration

* **commitlint:** ensure `upstream/master` uses main repo URL [skip ci] ([e20d7c6](https://github.com/saltstack-formulas/mysql-formula/commit/e20d7c69d12777365ff95c841decfe7dc05c4227))
* **gemfile+lock:** use `ssf` customised `kitchen-docker` repo [skip ci] ([63561c0](https://github.com/saltstack-formulas/mysql-formula/commit/63561c0a2f236722b4449717e83b421a021d7093))
* **gitlab-ci:** add `rubocop` linter (with `allow_failure`) [skip ci] ([d08b960](https://github.com/saltstack-formulas/mysql-formula/commit/d08b960daf910f9c386523ae3d942d851cca2802))
* **kitchen+ci:** use latest pre-salted images (after CVE) [skip ci] ([1af83d1](https://github.com/saltstack-formulas/mysql-formula/commit/1af83d1fac432c9208c968182979090348dab69c))
* **kitchen+gitlab-ci:** use latest pre-salted images [skip ci] ([b27382a](https://github.com/saltstack-formulas/mysql-formula/commit/b27382a76cf3f2fd40c5dc6934175186f2065720))
* **pre-commit:** update hook for `rubocop` [skip ci] ([86397f6](https://github.com/saltstack-formulas/mysql-formula/commit/86397f6390a6f5aab812dda258d3438674798af3))

# [0.55.0](https://github.com/saltstack-formulas/mysql-formula/compare/v0.54.2...v0.55.0) (2020-12-16)


### Bug Fixes

* **percona:** fix startswith error ([6b39bda](https://github.com/saltstack-formulas/mysql-formula/commit/6b39bda366af83b7080e056b2f3e00408689c44b))
* **redhat:** added missing client socket ([b0f370c](https://github.com/saltstack-formulas/mysql-formula/commit/b0f370cf8b60e2e8a9e281f945ae2ab435a2e63c))
* **redhat:** update python library, add missing  deps ([3cab000](https://github.com/saltstack-formulas/mysql-formula/commit/3cab000c89e5032dd7b7fc0c7cd7a68696e2445b))
* **server:** fix `salt-lint` violations [skip ci] ([2d1c7c3](https://github.com/saltstack-formulas/mysql-formula/commit/2d1c7c30e60b2f8a50a3964b82cb43cc5d54709b))


### Continuous Integration

* **gitlab-ci:** use GitLab CI as Travis CI replacement ([fb50e26](https://github.com/saltstack-formulas/mysql-formula/commit/fb50e26f6a2bfa38f8ed57981f4ba730cf43c34d))
* **pre-commit:** add to formula [skip ci] ([11e6460](https://github.com/saltstack-formulas/mysql-formula/commit/11e646082ec3846045edde20411615c7c0f3479b))
* **pre-commit:** enable/disable `rstcheck` as relevant [skip ci] ([87cb5b7](https://github.com/saltstack-formulas/mysql-formula/commit/87cb5b7c4f6096902dd97a4eeda2c238de5b0fa9))
* **pre-commit:** finalise `rstcheck` configuration [skip ci] ([92bf43a](https://github.com/saltstack-formulas/mysql-formula/commit/92bf43a3b79fa3b1cee0f43de98dd9aac1ea2a6c))


### Features

* **credentials:** add socket access ([1c70b0a](https://github.com/saltstack-formulas/mysql-formula/commit/1c70b0abc106fbce2d7f95feaf9f02dd64cddfcf))

## [0.54.2](https://github.com/saltstack-formulas/mysql-formula/compare/v0.54.1...v0.54.2) (2020-08-27)


### Bug Fixes

* **indent:** properly indent file.directory block ([7791268](https://github.com/saltstack-formulas/mysql-formula/commit/7791268d133d557d21414365db59dc14c8f97f74)), closes [#250](https://github.com/saltstack-formulas/mysql-formula/issues/250)

## [0.54.1](https://github.com/saltstack-formulas/mysql-formula/compare/v0.54.0...v0.54.1) (2020-08-24)


### Bug Fixes

* **freebsd:** upgrade to mysql57-server ([ec68199](https://github.com/saltstack-formulas/mysql-formula/commit/ec681995b4f7e23a8dbec63809d3704f19ec9299))

# [0.54.0](https://github.com/saltstack-formulas/mysql-formula/compare/v0.53.0...v0.54.0) (2020-07-10)


### Continuous Integration

* **kitchen:** use `saltimages` Docker Hub where available [skip ci] ([b37a8a7](https://github.com/saltstack-formulas/mysql-formula/commit/b37a8a7c970cb30ed18f04c4103c5f553557699d))


### Features

* **socket_authentication:** allow unix_socket authentication ([8eccd5a](https://github.com/saltstack-formulas/mysql-formula/commit/8eccd5a68cadde02f54467a7fb9e370d2ee7d574))

# [0.53.0](https://github.com/saltstack-formulas/mysql-formula/compare/v0.52.7...v0.53.0) (2020-06-01)


### Continuous Integration

* **kitchen+travis:** use latest pre-salted images ([7ea518a](https://github.com/saltstack-formulas/mysql-formula/commit/7ea518a3919f1a59bc6ae821bc0df7577629059a))
* **travis:** add notifications => zulip [skip ci] ([8adfc4b](https://github.com/saltstack-formulas/mysql-formula/commit/8adfc4bb4fbb49548cf46d277a0403b89c180b1a))


### Features

* **focal:** add settings for `ubuntu-20.04` ([0d77164](https://github.com/saltstack-formulas/mysql-formula/commit/0d77164f394909ec371f39cb41a4920c82e75052))

## [0.52.7](https://github.com/saltstack-formulas/mysql-formula/compare/v0.52.6...v0.52.7) (2020-05-19)


### Bug Fixes

* **osfamilymap.yaml:** update SUSE defaults ([8ee79a7](https://github.com/saltstack-formulas/mysql-formula/commit/8ee79a7bb03488e4c3632a1dcfe143696a11aad5))


### Continuous Integration

* **gemfile.lock:** add to repo with updated `Gemfile` [skip ci] ([9e9fa3e](https://github.com/saltstack-formulas/mysql-formula/commit/9e9fa3e3d15e25ad22f75eae61af4883c79b7c0f))
* **kitchen+travis:** remove `master-py2-arch-base-latest` [skip ci] ([c1dddc3](https://github.com/saltstack-formulas/mysql-formula/commit/c1dddc3a8d561847094bbe23fe2c764c8fdf79de))
* **workflows/commitlint:** add to repo [skip ci] ([b4c6570](https://github.com/saltstack-formulas/mysql-formula/commit/b4c65702b91e8813741bf72008e41d1d8dfc735d))

## [0.52.6](https://github.com/saltstack-formulas/mysql-formula/compare/v0.52.5...v0.52.6) (2020-04-17)


### Bug Fixes

* **reload-modules:** do `reload_modules` on py module installation ([2b6e704](https://github.com/saltstack-formulas/mysql-formula/commit/2b6e704c96d0373aadb56f90d758c960f538abdb))


### Continuous Integration

* **gemfile:** restrict `train` gem version until upstream fix [skip ci] ([04f75a7](https://github.com/saltstack-formulas/mysql-formula/commit/04f75a7a3b43de9425a8f36dc202b7ecf0c4f856))
* **kitchen:** avoid using bootstrap for `master` instances [skip ci] ([ef7a2ce](https://github.com/saltstack-formulas/mysql-formula/commit/ef7a2ce2d857dd271ec0704ab951c8337cb6b64e))
* **travis:** use `major.minor` for `semantic-release` version [skip ci] ([b4f5f79](https://github.com/saltstack-formulas/mysql-formula/commit/b4f5f79781631d7d31061b880df3066ac5bc5860))

## [0.52.5](https://github.com/saltstack-formulas/mysql-formula/compare/v0.52.4...v0.52.5) (2019-12-10)


### Bug Fixes

* **db_load:** preserve space between -h and -p on the db load `cmd.wait` ([a05f263](https://github.com/saltstack-formulas/mysql-formula/commit/a05f263f4b9eac52a5854fd57a6a24f997ccb291))

## [0.52.4](https://github.com/saltstack-formulas/mysql-formula/compare/v0.52.3...v0.52.4) (2019-12-03)


### Styles

* remove previous line from jinja directives ([ec0e2a7](https://github.com/saltstack-formulas/mysql-formula/commit/ec0e2a765a587d0df94b0afb9f7a4ef78a5319ab))

## [0.52.3](https://github.com/saltstack-formulas/mysql-formula/compare/v0.52.2...v0.52.3) (2019-12-03)


### Bug Fixes

* **mac_shortcut.sh:** fix `shellcheck` errors ([7b309f8](https://github.com/saltstack-formulas/mysql-formula/commit/7b309f8da272ebdcb36dbfa7619a0fc9872a79a7))
* **release.config.js:** use full commit hash in commit link [skip ci] ([3f51b8b](https://github.com/saltstack-formulas/mysql-formula/commit/3f51b8bbc231a7455e6763b415221abff636d8a2))


### Continuous Integration

* **kitchen:** use `debian-10-master-py3` instead of `develop` [skip ci] ([5efe938](https://github.com/saltstack-formulas/mysql-formula/commit/5efe9387fde63e0c09d99d5771f3b623fb934242))
* **kitchen:** use `develop` image until `master` is ready (`amazonlinux`) [skip ci] ([63bfb4a](https://github.com/saltstack-formulas/mysql-formula/commit/63bfb4a0f25b62bdc45c1738d438ce5ec64f2183))
* **kitchen+travis:** upgrade matrix after `2019.2.2` release [skip ci] ([27ac5a3](https://github.com/saltstack-formulas/mysql-formula/commit/27ac5a3f684325a8e15736bb85d4774807061534))
* **travis:** apply changes from build config validation [skip ci] ([d520848](https://github.com/saltstack-formulas/mysql-formula/commit/d520848c815a9c2815ee3f1943e3e3962a26c7cf))
* **travis:** opt-in to `dpl v2` to complete build config validation [skip ci] ([1a8d914](https://github.com/saltstack-formulas/mysql-formula/commit/1a8d914fbd5e43f78ee2334b9c5ccd51ee65ad57))
* **travis:** quote pathspecs used with `git ls-files` [skip ci] ([3fb5a82](https://github.com/saltstack-formulas/mysql-formula/commit/3fb5a82de66dda9a05decc5ee7263729ef913533))
* **travis:** run `shellcheck` during lint job [skip ci] ([0931835](https://github.com/saltstack-formulas/mysql-formula/commit/0931835f1cfc77022a43242bd3ab04cbed2a3a02))
* **travis:** update `salt-lint` config for `v0.0.10` [skip ci] ([1512279](https://github.com/saltstack-formulas/mysql-formula/commit/1512279c2eac26638720461cc7e847d93d2c77d6))
* **travis:** use build config validation (beta) [skip ci] ([40d4b97](https://github.com/saltstack-formulas/mysql-formula/commit/40d4b9763f252f5811d31b2b2df156260bde2b6d))


### Documentation

* **contributing:** remove to use org-level file instead [skip ci] ([6afcc80](https://github.com/saltstack-formulas/mysql-formula/commit/6afcc80396dc4ec2044d8611f18a6ed9075c6a52))
* **readme:** update link to `CONTRIBUTING` [skip ci] ([01f25a3](https://github.com/saltstack-formulas/mysql-formula/commit/01f25a3ebfbf59d1db2bec73bc5fef9d8bcafd7e))


### Performance Improvements

* **travis:** improve `salt-lint` invocation [skip ci] ([1980c63](https://github.com/saltstack-formulas/mysql-formula/commit/1980c634b9021c7d29be914bd2a63ddf3c31c8ad))

## [0.52.2](https://github.com/saltstack-formulas/mysql-formula/compare/v0.52.1...v0.52.2) (2019-10-11)


### Bug Fixes

* **rubocop:** add fixes using `rubocop --safe-auto-correct` ([](https://github.com/saltstack-formulas/mysql-formula/commit/fca3b04))


### Continuous Integration

* merge travis matrix, add `salt-lint` & `rubocop` to `lint` job ([](https://github.com/saltstack-formulas/mysql-formula/commit/b2b8863))
* **travis:** merge `rubocop` linter into main `lint` job ([](https://github.com/saltstack-formulas/mysql-formula/commit/26dc562))

## [0.52.1](https://github.com/saltstack-formulas/mysql-formula/compare/v0.52.0...v0.52.1) (2019-10-10)


### Bug Fixes

* **server.sls:** fix `salt-lint` errors ([](https://github.com/saltstack-formulas/mysql-formula/commit/764dd0c))
* **user.sls:** fix `salt-lint` errors ([](https://github.com/saltstack-formulas/mysql-formula/commit/a014e55))


### Continuous Integration

* **kitchen:** change `log_level` to `debug` instead of `info` ([](https://github.com/saltstack-formulas/mysql-formula/commit/75fd8dc))
* **kitchen:** install required packages to bootstrapped `opensuse` [skip ci] ([](https://github.com/saltstack-formulas/mysql-formula/commit/8b89ebc))
* **kitchen:** use bootstrapped `opensuse` images until `2019.2.2` [skip ci] ([](https://github.com/saltstack-formulas/mysql-formula/commit/4bdaab7))
* **platform:** add `arch-base-latest` (commented out for now) [skip ci] ([](https://github.com/saltstack-formulas/mysql-formula/commit/5c20c9b))
* **yamllint:** add rule `empty-values` & use new `yaml-files` setting ([](https://github.com/saltstack-formulas/mysql-formula/commit/2322ff6))
* merge travis matrix, add `salt-lint` & `rubocop` to `lint` job ([](https://github.com/saltstack-formulas/mysql-formula/commit/00494d5))
* use `dist: bionic` & apply `opensuse-leap-15` SCP error workaround ([](https://github.com/saltstack-formulas/mysql-formula/commit/05b1cef))

# [0.52.0](https://github.com/saltstack-formulas/mysql-formula/compare/v0.51.0...v0.52.0) (2019-08-17)


### Features

* **yamllint:** include for this repo and apply rules throughout ([9f739fa](https://github.com/saltstack-formulas/mysql-formula/commit/9f739fa))

# [0.51.0](https://github.com/saltstack-formulas/mysql-formula/compare/v0.50.0...v0.51.0) (2019-08-08)


### Bug Fixes

* **connector:** fix typos (connnector) and missing `enabled` ([bdee94a](https://github.com/saltstack-formulas/mysql-formula/commit/bdee94a))


### Features

* **linux:** archlinux support (no osmajorrelase grain) ([4b4ad88](https://github.com/saltstack-formulas/mysql-formula/commit/4b4ad88))

# [0.50.0](https://github.com/saltstack-formulas/mysql-formula/compare/v0.49.0...v0.50.0) (2019-07-12)


### Features

* **semantic-release:** implement for this formula ([1d2e2f5](https://github.com/saltstack-formulas/mysql-formula/commit/1d2e2f5))
