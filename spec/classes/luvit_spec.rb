require 'spec_helper'

describe 'luvit' do

  let(:hiera_config) { 'spec/fixtures/hiera/hiera.yaml' }

  it { should contain_class('singleton') }
  it { should contain_package('singleton_package_make') }
  it { should contain_package('singleton_package_gcc') }
  it { should contain_package('singleton_package_wget') }

  context "with default param" do

    it do
      should contain_exec('download luvit').with({
        'cwd'     => '/tmp',
        'path'    => '/bin:/usr/bin',
        'command' => 'wget http://luvit.io/dist/latest/luvit-0.7.0.tar.gz',
        'creates' => '/tmp/luvit-0.7.0.tar.gz',
        'notify'  => 'Exec[untar luvit]',
        'require' => 'Package[wget]',
      })
    end

    it do
      should contain_exec('untar luvit').with({
        'cwd'     => '/tmp',
        'path'    => '/bin:/usr/bin',
        'command' => 'tar -zxvf luvit-0.7.0.tar.gz',
        'creates' => '/tmp/luvit-0.7.0/Makefile',
        'notify' => 'Exec[install luvit]',
      })
    end

    it do
      should contain_exec('install luvit').with({
        'cwd'     => '/tmp/luvit-0.7.0',
        'path'    => '/bin:/usr/bin',
        'command' => 'make && make install',
        'creates' => '/usr/local/bin/luvit',
        'require' => ['Package[gcc]', 'Package[make]'],
      })
    end

  end

end