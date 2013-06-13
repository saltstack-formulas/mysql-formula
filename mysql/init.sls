mysql:
  pkg:
    - installed
    {% if grains['os_family'] == 'Debian' %}
    - pkgs:
      - mysql-client
      - mysql-server
    {% endif %}

