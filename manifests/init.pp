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
#     version => '0.7.0',
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
  $version                = hiera('luvit::version'),
  $tmp                    = hiera('luvit::tmp', '/tmp'),
) {

  singleton_packages('gcc', 'make', 'wget', 'git')

  exec { 'download luvit':
    cwd     => $tmp,
    path    => '/bin:/usr/bin',
    command => "wget http://luvit.io/dist/latest/luvit-${version}.tar.gz",
    creates => "${tmp}/luvit-${version}.tar.gz",
    notify  => Exec['untar luvit'],
    require => Package['wget'],
  }

  exec { 'untar luvit':
    cwd     => $tmp,
    path    => '/bin:/usr/bin',
    command => "tar -zxvf luvit-${version}.tar.gz",
    creates => "${tmp}/luvit-${version}/Makefile",
    notify  => Exec['install luvit'],
  }

  exec { 'install luvit':
    cwd     => "${tmp}/luvit-${version}",
    command => 'make && make install',
    path    => '/bin:/usr/bin',
    creates => '/usr/local/bin/luvit',
    require => Package['gcc', 'make'],
  }

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

  exec { 'download lum':
    cwd     => $tmp,
    path    => '/bin:/usr/bin',
    command => 'git clone https://github.com/radare/lum.git',
    creates => "${tmp}/lum/Makefile",
    notify  => Exec['install lum'],
    require => Package['git'],
  }

  exec { 'install lum':
    cwd     => "${tmp}/lum",
    path    => '/bin:/usr/bin',
    command => 'make install',
    creates => '/usr/bin/lum',
    require => Package['make'],
  }
}