# frozen_string_literal: true

# Override by OS.
package_name = 'mariadb-server'
if (os[:name] == 'suse') || (os[:name] == 'opensuse')
  package_name = 'mariadb'
elsif os[:release].start_with?('8') && %w[debian centos].include?(os[:name])
  package_name = 'mysql-server'
end

control 'mysql package' do
  title 'should be installed'

  describe package(package_name) do
    it { should be_installed }
  end
end
