# Class: php::cli
#
# Command Line Interface PHP. Useful for console scripts, cron jobs etc.
# To customize the behavior of the php binary, see php::ini.
#
# Sample Usage:
#  include php::cli
#
class php::cli (
  $ensure   = 'installed',
  $inifile  = '/etc/php.ini',
  $package  = undef,
  ) {

  include '::php::params'

  $cli_package_name = $package ? {
    undef   => $::php::params::cli_package_name,
    default => $package,
  }
  package { $cli_package_name :
    ensure  => $ensure,
  }
}
