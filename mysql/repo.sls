include:
  - mysql.config

{% from "mysql/defaults.yaml" import rawmap with context %}
{%- set mysql = salt['grains.filter_by'](rawmap, grain='os', merge=salt['pillar.get']('mysql:lookup')) %}

# Completely ignore non-RHEL based systems
# TODO: Add Debian and Suse systems.
# TODO: Allow user to specify MySQL version and alter yum repo file accordingly.
{% if grains['os_family'] == 'RedHat' %}
  {% if grains['osmajorrelease'][0] == '5' %}
  {% set rpm_source = "http://repo.mysql.com/mysql57-community-release-el5.rpm" %}
  {% elif grains['osmajorrelease'][0] == '6' %}
  {% set rpm_source = "http://repo.mysql.com/mysql57-community-release-el6.rpm" %}
  {% elif grains['osmajorrelease'][0] == '7' %}
  {% set rpm_source = "http://repo.mysql.com/mysql57-community-release-el7.rpm" %}
  {% endif %}
{% endif %}

{% set mysql57_community_release = salt['pillar.get']('mysql:release', false) %}
# A lookup table for MySQL Repo GPG keys & RPM URLs for various RedHat releases
  {% set pkg = {
    'key': 'http://repo.mysql.com/RPM-GPG-KEY-mysql',
    'key_hash': 'md5=472a4a4867adfd31a68e8c9bbfacc23d',
    'rpm': rpm_source
 } %}


install_pubkey_mysql:
  file.managed:
    - name: /etc/pki/rpm-gpg/RPM-GPG-KEY-mysql
    - source: {{ salt['pillar.get']('mysql:pubkey', pkg.key) }}
    - source_hash:  {{ salt['pillar.get']('mysql:pubkey_hash', pkg.key_hash) }}

mysql57_community_release:
  pkg.installed:
    - sources:
      - mysql57-community-release: {{ salt['pillar.get']('mysql:repo_rpm', pkg.rpm) }}
    - require:
      - file: install_pubkey_mysql
    - require_in:
      {% if "server_config" in mysql %}
      - pkg: {{ mysql.server }}
      {% endif %}
      {% if "clients_config" in mysql %}
      - pkg: {{ mysql.client }}
      {% endif %}

set_pubkey_mysql:
  file.replace:
    - append_if_not_found: True
    - name: /etc/yum.repos.d/mysql-community.repo
    - pattern: '^gpgkey=.*'
    - repl: 'gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mysql'
    - require:
      - pkg: mysql57_community_release

set_gpg_mysql:
  file.replace:
    - append_if_not_found: True
    - name: /etc/yum.repos.d/mysql-community.repo
    - pattern: 'gpgcheck=.*'
    - repl: 'gpgcheck=1'
    - require:
      - pkg: mysql57_community_release
