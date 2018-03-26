check_pillar_for_root_password:
  test.check_pillar:
    - present:
      - mysql:server:root_password
