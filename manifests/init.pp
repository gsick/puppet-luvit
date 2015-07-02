# = Class: luvit
#
# This class installs and Luvit.
#
# == Parameters:
#
# $master:: Last version or master branch.
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
#
#   }
#
# == Authors
#
# Gamaliel Sick
#
# == Copyright
#
# Copyright 2015 Gamaliel Sick, unless otherwise noted.
#
class luvit(
  $master = false,
  $tmp    = '/tmp',
) {

  validate_bool($master)
  validate_absolute_path($tmp)

  ensure_packages(['curl'])

  # Install lit
  exec { 'download lit script':
    cwd     => $tmp,
    path    => '/bin:/usr/bin',
    command => "curl -L https://github.com/luvit/lit/raw/master/get-lit.sh -o get-lit.sh \
                && chmod +x get-lit.sh",
    creates => "${tmp}/get-lit.sh",
    require => Package['curl'],
  }

  exec { 'build lit':
    cwd     => $tmp,
    path    => '/bin:/usr/bin',
    command => './get-lit.sh',
    creates => ["${tmp}/lit", "${tmp}/luvi"],
    require => Exec['download lit script'],
  }

  exec { 'install lit':
    cwd     => $tmp,
    path    => '/bin:/usr/bin',
    command => 'cp lit /usr/local/bin \
                && cp luvi /usr/local/bin \
                && ln -s /usr/local/bin/lit /bin/lit \
                && ln -s /usr/local/bin/luvi /bin/luvi',
    creates => ['/bin/lit', '/bin/luvi'],
    require => Exec['build lit'],
  }

  # Install Luvit
  $command = $master ? {
    true    => 'lit make github://luvit/luvit',
    default => 'lit make lit://luvit/luvit'
  }

  exec { 'build luvit':
    cwd     => $tmp,
    path    => '/bin:/usr/bin',
    command => $command,
    creates => "${tmp}/luvit",
    require => Exec['install lit'],
  }

  exec { 'install luvit':
    cwd     => $tmp,
    path    => '/bin:/usr/bin',
    command => 'cp luvit /usr/local/bin \
                && ln -s /usr/local/bin/luvit /bin/luvit',
    creates => '/bin/luvit',
    require => Exec['build luvit'],
  }
}
