# = Class: luvit
#
# This class installs and Luvit.
#
# == Parameters:
#
# $version:: The version of Luvit to download.
#
# $tmp::  Temp directory.
#
# == Requires:
#
# Nothing
#
# == Sample Usage:
#
#   class {'luvit':
#     version => '0.8.2',
#   }
#
# == Authors
#
# Gamaliel Sick
#
# == Copyright
#
# Copyright 2014 Gamaliel Sick, unless otherwise noted.
#
class luvit(
  $version,
  $install_lum = false,
  $tmp         = '/tmp',
) {

  ensure_packages(['gcc'])

  exec { 'install luvit':
    cwd     => $tmp,
    path    => '/bin:/usr/bin',
    command => "mkdir -p /usr/src/luvit \
                && curl -sSL \"http://luvit.io/dist/latest/luvit-${version}.tar.gz\" -o luvit.tar.gz \
                && tar -xzf luvit.tar.gz -C /usr/src/luvit --strip-components=1 \
                && rm -f luvit.tar.gz \
                && make -C /usr/src/luvit \
                && make -C /usr/src/luvit install \
                && rm -rf /usr/src/luvit",
    creates => '/usr/local/bin/luvit',
    require => Package['gcc'],
  }

  # TODO remove gcc

  if($install_lum) {
    ensure_packages(['git'])

    file { 'lum conf dir':
      ensure => directory,
      path   => '/root/.lum',
    }

    exec { 'repo':
      cwd     => '/',
      command => 'echo REPOS=http://lolcathost.org/lum/pancake >> ~/.lum/config',
      path    => '/bin:/usr/bin',
      creates => '/root/.lum/config',
      require => File['lum conf dir'],
    }

    exec { 'install lum':
      cwd     => $tmp,
      path    => '/bin:/usr/bin',
      command => "cd /usr/src && git clone https://github.com/radare/lum.git \
                  && make -C /usr/src/lum install \
                  && rm -rf /usr/src/lum",
      creates => '/usr/bin/lum',
      require => Package['git'],
    }
  }
}
