# Class: php::fpm::systemd-daemon
#
# Install the PHP FPM daemon. See php::fpm::systemd-socket-conf for configuring its pools.
#
# Sample Usage:
#  include php::fpm::systemd-daemon
#
class php::fpm::systemd-daemon (
  $ensure                      = 'present',
  $package_name                = $::php::params::fpm_package_name,
  $fpm_pool_dir                = $::php::params::fpm_pool_dir,
  $fpm_conf_dir                = $::php::params::fpm_conf_dir,
  $log_owner                   = 'apache',
  $log_group                   = 'apache',
) inherits ::php::params {

  # Hack-ish to default to user for group too
  $log_group_final = $log_group ? {
    false   => $log_owner,
    default => $log_group,
  }

  package { $package_name: ensure => $ensure }

  if ( $ensure != 'absent' ) {

    # Create "/var/run/php-fpm/php-systemd/" as group-writable because the daemon does not start as root
    file { "/var/run/php-fpm/php-systemd/":
      ensure => 'directory',
      owner  => $log_owner,
      group  => $log_group_final,
			mode	 => '0775',
    }

  }

}

