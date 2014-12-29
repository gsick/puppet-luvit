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
  $tmp     = '/tmp',
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
                && rm -r /usr/src/luvit",
    creates => '/usr/local/bin/luvit',
    require => Package['gcc'],
  }

}
