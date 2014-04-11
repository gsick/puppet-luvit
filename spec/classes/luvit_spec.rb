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
        'notify'  => 'Exec[install luvit]',
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

    it do
      should contain_file('lum conf dir').with({
        'ensure'    => 'directory',
        'path'      => '~/.lum',
      })
    end

    it do
      should contain_exec('repo').with({
        'cwd'     => '/',
        'path'    => '/bin:/usr/bin',
        'command' => 'echo REPOS=http://lolcathost.org/lum/pancake >> ~/.lum/config',
        'creates' => '~/.lum/config',
        'require' => 'File[lum conf dir]',
      })
    end

    it do
      should contain_exec('download lum').with({
        'cwd'     => '/tmp',
        'path'    => '/bin:/usr/bin',
        'command' => 'git clone https://github.com/radare/lum.git',
        'creates' => '/tmp/lum/Makefile',
        'require' => 'Package[git]',
        'notify'  => 'Exec[install lum]',
      })
    end

    it do
      should contain_exec('install lum').with({
        'cwd'     => '/tmp/lum',
        'path'    => '/bin:/usr/bin',
        'command' => 'make install',
        'creates' => '/usr/bin/lum',
        'require' => 'Package[make]',
      })
    end

  end

end