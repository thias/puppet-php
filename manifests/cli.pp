# Class: php::cli
#
# Command Line Interface PHP. Useful for console scripts, cron jobs etc.
# To customize the behavior of the php binary, see php::ini.
#
# Sample Usage:
#  include php::cli
#
class php::cli (
  $ensure           = 'installed',
  $inifile          = '/etc/php.ini',
) inherits ::php::params {
  $cli_package_name = "${::php::php_name}${::php::params::cli_package_suffix}"
  package { $cli_package_name:
    ensure  => $ensure,
    require => File[$inifile],
  }
}

