# frozen_string_literal: true

# Override by platform.
package_name =
  case system.platform[:finger]
  when 'opensuse-tumbleweed', 'opensuse-15'
    'mariadb'
  when 'debian-8', 'centos-8', 'ubuntu-22.04'
    'mysql-server'
  else
    'mariadb-server'
  end

control 'mysql package' do
  title 'should be installed'

  describe package(package_name) do
    it { should be_installed }
  end
end
