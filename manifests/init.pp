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

  singleton_packages('gcc', 'make', 'wget')

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
}