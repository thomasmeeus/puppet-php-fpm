require 'spec_helper_acceptance'

describe 'php-fpm' do

  describe 'running puppet code' do
    it 'should work with no errors' do
      pp = <<-EOS
        class { 'php-fpm':
          user           => 'apache',
          group          => 'apache',
          listen_address => '/tmp/php-fpm.sock',
        }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe file('/tmp/php-fpm.sock') do
      it { should be_socket }
    end

    describe service('php-fpm') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
