# frozen_string_literal: true

# Override by platform.
package_name =
  case system.platform[:finger]
  when /^(open)suse-/
    'mariadb'
  when /amazon/
    'mariadb123-server'
  else
    'mariadb-server'
  end

control 'mysql package' do
  title 'should be installed'

  describe package(package_name) do
    it { should be_installed }
  end
end
