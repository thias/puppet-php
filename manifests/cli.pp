# Class: php::cli
#
# Command Line Interface PHP. Useful for console scripts, cron jobs etc.
# To customize the behavior of the php binary, see php::ini.
#
# Sample Usage:
#  include php::cli
#
class php::cli(
  $inifile = '/etc/php.ini'
) inherits php::params {
  package { $cli_package_name:
    ensure  => installed,
    require => File[$inifile],
  }
}

